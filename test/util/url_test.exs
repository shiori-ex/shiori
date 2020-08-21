defmodule ShioriTest.Util.URL do
  use ExUnit.Case
  import Shiori.Util.URL

  test "URL pattern validation" do
    assert "https://example.com" |> valid?()
    assert "www.example.com" |> valid?()
    assert "https://example.com/aasd/asd%20bc?query=123123&kekw=lel#asd" |> valid?()

    refute "example.com" |> valid?()
    refute "" |> valid?()
    refute "asdasd.asdasd/asdasd" |> valid?()
  end
end
