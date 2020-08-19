defmodule Shiori.Models.Link do
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

  def from_map(map) do
    %__MODULE__{
      id: map["id"],
      url: map["url"],
      description: map["description"],
      tags: map["tags"]
    }
  end
end
