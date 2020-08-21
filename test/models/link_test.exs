defmodule ShioriTest.Models.Link do
  use ExUnit.Case
  alias Shiori.Models.Link, as: Link

  test "hydrate id_str to map" do
    map = %{"id" => 450_355_460_575_232} |> Link.add_id_str()
    assert map["id_str"] == "450355460575232"
  end

  test "hydrate id_str to list of maps" do
    ids = [450_355_460_575_232, 450_355_460_575_233, 450_355_460_575_234]
    id_strs = ["450355460575232", "450355460575233", "450355460575234"]

    id_strs_rec =
      ids
      |> Enum.map(fn i -> %{"id" => i} end)
      |> Link.add_id_str()
      |> Enum.map(fn l -> l["id_str"] end)

    assert id_strs == id_strs_rec
  end
end
