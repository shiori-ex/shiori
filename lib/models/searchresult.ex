defmodule Shiori.Models.SearchResult do
  @moduledoc """
  Response model of a database search result.
  """

  alias Shiori.Models.Link, as: Link

  @type t() :: %__MODULE__{
          hits: [Link.t()],
          processing_time_ms: integer(),
          query: String.t()
        }

  @derive Jason.Encoder
  defstruct hits: [],
            processing_time_ms: nil,
            query: nil

  @doc """
  Returns a SearchResult from the given
  map values.
  """
  def from_map(map) do
    %__MODULE__{
      hits: map["hits"],
      processing_time_ms: map["processingTimeMs"],
      query: map["query"]
    }
  end

  def add_id_str(res),
    do: %{res | hits: res.hits |> Link.add_id_str()}
end
