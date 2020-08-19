defmodule Shiori.Snowflake.Server do
  use GenServer

  alias Shiori.Snowflake.Node, as: Node

  def init(args) do
    {:ok, args}
  end

  def start_link(opts) do
    node = %Node{
      id: opts[:id]
    }

    GenServer.start_link(__MODULE__, node, opts)
  end

  def handle_call({:get_id}, _from, node) do
    {node, id} = node |> Node.generate()
    {:reply, id, node}
  end

  def get_id(server) do
    GenServer.call(server, {:get_id})
  end
end
