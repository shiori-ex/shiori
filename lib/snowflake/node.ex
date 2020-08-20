defmodule Shiori.Snowflake.Node do
  use Bitwise

  @moduledoc """
  Represents a snowflake node state
  holder used to generate unique
  IDs on a millisecond timestamp basis.
  """

  @type t() :: %__MODULE__{
          id: integer(),
          last_timestamp: integer(),
          increment: integer()
        }

  defstruct id: 0, last_timestamp: 0, increment: 0

  #########################################################
  #
  #   Snowflake ID Structure
  #
  #   | < 42 > | < 10 > | < 12 > |
  #   | 64..22 | 22..13 | 12..00 |
  #     ^        ^        ^
  #     |        |        +- Increment
  #     |        +---------- Node ID
  #     +------------------- Timestamp
  #                          (milliseconds since epoche)
  #
  #########################################################

  # Mon Jul 11 09:19:55 52603 UTC
  @epoche 1_597_839_643_195
  @increment_bits 12
  @increment_max -1 ^^^ (-1 <<< @increment_bits)
  @increment_mask @increment_max
  @node_bits 10
  @node_max -1 ^^^ (-1 <<< @node_bits)
  @node_mask @node_max <<< @increment_bits

  @doc """
  Generates a unique snowflake ID by the current
  timestamp as milliseconds, the node ID and an
  increment counter which is increased when another
  ID was created when last_timestamp is equal to
  current timestamp.

  A tuple containing the node state and the ID
  is returned.

  This function might raise an error when either
  the node ID is larger than specified or the
  increment exceeds the specified max value for
  the increment number.
  """
  @spec generate(__MODULE__) :: {__MODULE__, integer()}
  def generate(node) do
    if node.id > @node_max do
      raise "Node max (#{@node_max}) exceeded"
    end

    now = System.system_time(:millisecond) - @epoche

    if node.last_timestamp == now do
      if node.increment >= @increment_max do
        raise "Increment max (#{@increment_max}) exceeded"
      end

      %{node | increment: node.increment + 1} |> get_id(now)
    else
      %{node | increment: 0, last_timestamp: now} |> get_id(now)
    end
  end

  @doc """
  Returns the timestamp in milliseconds of the passed
  snowflake ID when the ID was generated.
  """
  @spec get_timestamp(integer()) :: integer()
  def get_timestamp(id), do: (id >>> (@increment_bits + @node_bits)) + @epoche

  @doc """
  Returns the node ID of the passed snowflake ID
  which was used to generate the ID.
  """
  @spec get_nodeid(integer()) :: integer()
  def get_nodeid(id), do: (id &&& @node_mask) >>> @increment_bits

  @doc """
  Returns the increment number of the passed snowflake
  ID which was assigned when it was created.

  This number can be interpreted as the (n + 1)th ID
  generated on the same node in between the same
  millisecond.
  """
  @spec get_increment(integer()) :: integer()
  def get_increment(id), do: id &&& @increment_mask

  defp get_id(node, now) do
    id =
      now <<< (@increment_bits + @node_bits) |||
        node.id <<< @increment_bits |||
        node.increment

    {node, id}
  end
end
