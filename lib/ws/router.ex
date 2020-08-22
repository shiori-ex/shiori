defmodule Shiori.WS.Router do
  require Logger

  import Shiori.WS.Util

  alias Shiori.Models.Link, as: Link
  alias Shiori.Models.SearchResult, as: SearchResult
  alias Shiori.Snowflake.Server, as: SnowflakeServer

  use Plug.Router
  use Plug.ErrorHandler

  @prefix Shiori.Config.get_sub(WS, :prefix, "/api")

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(Shiori.WS.Cors)
  plug(Shiori.WS.Auth.Basic)
  plug(:match)
  plug(:dispatch)

  ###############################################################
  #  GET /api/links
  #                ?limit=number(100)
  #                ?offset=number(0)
  ###############################################################

  get "#{@prefix}/links" do
    conn |> fetch_query_params()
    limit = conn.query_params |> Map.get("limit", 100)
    offset = conn.query_params |> Map.get("offset", 0)

    case Meilisearch.Document.list(
           "links",
           limit: limit,
           offset: offset
         ) do
      {:error, 404, _err} -> conn |> resp_json_not_found()
      {:error, _code, err} -> conn |> resp_json_error(500, err)
      {:ok, docs} -> docs |> Link.add_id_str() |> resp_json_ok(conn)
    end
  end

  ###############################################################
  #  GET /api/links/search
  #                       ?query=string
  #                       ?limit=number(100)
  #                       ?offset=number(0)
  ###############################################################

  get "#{@prefix}/links/search" do
    conn |> fetch_query_params()
    query = conn.query_params |> Map.get("query")
    limit = conn.query_params |> Map.get("limit", 100)
    offset = conn.query_params |> Map.get("offset", 0)

    if query == nil or query == "" do
      conn |> resp_json_error(400, "invalid query")
    end

    case Meilisearch.Search.search(
           "links",
           query,
           limit: limit,
           offset: offset
         ) do
      {:error, 404, _err} ->
        conn |> resp_json_not_found()

      {:error, _code, err} ->
        conn |> resp_json_error(500, err)

      {:ok, res} ->
        res
        |> SearchResult.from_map()
        |> SearchResult.add_id_str()
        |> resp_json_ok(conn)
    end
  end

  ###############################################################
  #  GET /api/links/:id
  ###############################################################

  get "#{@prefix}/links/:id" do
    case Meilisearch.Document.get("links", id) do
      {:error, 404, _err} -> conn |> resp_json_not_found()
      {:error, _code, err} -> conn |> resp_json_error(500, err)
      {:ok, doc} -> doc |> Link.add_id_str() |> resp_json_ok(conn)
    end
  end

  ###############################################################
  #  POST /api/links
  ###############################################################

  post "#{@prefix}/links" do
    conn |> read_body()

    link =
      conn.body_params
      |> Link.from_map()
      |> generate_and_set_id()

    if link |> Link.valid?() == false do
      conn |> resp_json_error(400, "invalid bookmark URL")
    end

    case ensure_links_index() do
      {:error, err} -> conn |> resp_json_error(500, err)
      _ -> conn
    end

    case Meilisearch.Document.add_or_replace("links", [link]) do
      {:error, err} -> conn |> resp_json_error(500, err)
      {:ok, _} -> link |> Link.add_id_str() |> resp_json(conn, 201)
    end
  end

  ###############################################################
  #  PUT /api/links/:id
  ###############################################################

  put "#{@prefix}/links/:id" do
    conn |> read_body()

    link =
      conn.body_params
      |> Link.from_map()

    if link |> Link.valid?() == false do
      conn |> resp_json_error(400, "invalid bookmark URL")
    end

    case Meilisearch.Document.get("links", id) do
      {:error, 404, _err} ->
        conn |> resp_json_not_found()

      {:ok, doc} ->
        link = %{link | id: doc["id"]}

        case Meilisearch.Document.add_or_replace("links", [link]) do
          {:error, _code, err} ->
            conn |> resp_json_error(500, err)

          {:ok, _} ->
            link |> Link.add_id_str() |> resp_json_ok(conn)
        end
    end
  end

  ###############################################################
  #  DELETE /api/links/:id
  ###############################################################

  delete "#{@prefix}/links/:id" do
    case Meilisearch.Document.delete("links", id) do
      {:error, err} ->
        conn |> resp_json_error(500, err)

      {:ok, _} ->
        conn |> resp_json_ok()
    end
  end

  ###############################################################
  #  FALLBACK
  ###############################################################

  match _ do
    resp_json_not_found(conn)
  end

  Logger.info("WS running @ port #{Shiori.Config.get_sub(WS, :port, 8080)}")

  defp generate_and_set_id(obj) do
    %Link{obj | id: SnowflakeServer.get_id(:snowflake_server)}
  end

  defp ensure_links_index() do
    case Meilisearch.Index.exists?("links") do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> Meilisearch.Index.create("links", primary_key: "id")
      {:error, _code, err} -> {:error, err}
    end
  end
end
