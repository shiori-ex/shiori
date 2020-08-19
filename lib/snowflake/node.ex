defmodule Shiori.Snowflake.Node do
  use Bitwise

  @type t() :: %__MODULE__{
          id: integer(),
          last_timestamp: integer(),
          increment: integer()
        }

  defstruct id: 0, last_timestamp: 0, increment: 0

  # Mon Jul 11 09:19:55 52603 UTC
  @epoche 1_597_839_643_195

  def generate(node) do
    now = System.system_time(:millisecond) - @epoche

    if node.last_timestamp == now do
      %{node | increment: node.increment + 1} |> get_id(now)
    else
      %{node | increment: 0, last_timestamp: now} |> get_id(now)
    end
  end

  defp get_id(node, now) do
    id = now <<< 22 ||| node.id <<< 12 ||| node.increment
    {node, id}
  end
end
