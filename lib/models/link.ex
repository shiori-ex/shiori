defmodule Shiori.Models.Link do
  @moduledoc """
  Database and response model which represents
  a bookmark link enty.
  """

  @type t() :: %__MODULE__{
          id: integer(),
          url: String.t(),
          description: String.t(),
          tags: List.t()
        }

  @derive Jason.Encoder
  defstruct id: 0,
            url: "",
            description: "",
            tags: []

  @doc """
  Returns a Link from the given map values.
  """
  def from_map(map) do
    %__MODULE__{
      id: map["id"],
      url: map["url"],
      description: map["description"],
      tags: map["tags"]
    }
  end
end
