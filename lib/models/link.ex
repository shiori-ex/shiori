defmodule Shiori.Models.Link do
  @moduledoc """
  Database and response model which represents
  a bookmark link enty.
  """

  @type t() :: %__MODULE__{
          id: integer(),
          id_str: String.t(),
          url: String.t(),
          description: String.t(),
          tags: List.t()
        }

  @derive Jason.Encoder
  defstruct id: 0,
            id_str: nil,
            url: nil,
            description: nil,
            tags: []

  @doc """
  Returns a Link from the given map values.
  """
  def from_map(map) do
    %__MODULE__{
      id: map["id"],
      id_str: map["id_str"],
      url: map["url"],
      description: map["description"],
      tags: map["tags"]
    }
  end

  @doc """
  Adds a field named "id_str" to the passed map which
  contains the integer value from the "id" field of
  the map.
  """
  @spec add_id_str(map()) :: map()
  def add_id_str(link_map) when is_map(link_map),
    do: link_map |> Map.put("id_str", Integer.to_string(link_map["id"]))

  @doc """
  Adds a field named "id_str" to each map of the list
  of maps which contains the integer value from the "id"
  field of the map elements.
  """
  @spec add_id_str(list(map())) :: list(map())
  def add_id_str(link_map_list) when is_list(link_map_list),
    do: link_map_list |> Enum.map(&add_id_str/1)

  @doc """
  Returns true when the links URL matches a valid
  URL pattern.
  """
  @spec valid?(map()) :: boolean()
  def valid?(link_map) when is_map(link_map),
    do: link_map["url"] || "" |> Shiori.Util.URL.valid?()

  @doc """
  Returns true when the links URL matches a valid
  URL pattern.
  """
  @spec valid?(__MODULE__) :: boolean()
  def valid?(link) when is_struct(link),
    do: link.url || "" |> Shiori.Util.URL.valid?()
end
