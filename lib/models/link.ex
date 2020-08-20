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

  def add_id_str(node) when is_map(node),
    do: node |> Map.put("id_str", Integer.to_string(node["id"]))

  def add_id_str(node) when is_list(node),
    do: node |> Enum.map(&add_id_str/1)
end
