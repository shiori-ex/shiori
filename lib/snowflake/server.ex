defmodule Shiori.Snowflake.Server do
  use GenServer
  alias Shiori.Snowflake.Node, as: Node

  @moduledoc """
  GenServer to generate unique snowflake IDs
  based on the node state hold by the GenServer.
  """

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

  @doc """
  Sends a get_id call to the specified GenServer
  instance and returns the retrieved value.
  """
  def get_id(server) do
    GenServer.call(server, {:get_id})
  end
end
