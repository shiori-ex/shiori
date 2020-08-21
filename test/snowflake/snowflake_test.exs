defmodule ShioriTest.Snowflake.Server do
  use ExUnit.Case
  import Shiori.Snowflake.Server

  test "get snowflake ID" do
    assert get_id(:snowflake_server) > 0
  end
end

defmodule ShioriTest.Snowflake.Node do
  use ExUnit.Case
  use ExUnit.Callbacks

  import Shiori.Snowflake.Server
  import Shiori.Snowflake.Node

  setup_all do
    start_link(id: 1, name: TestSnowflakeServer.General)
    start_link(id: 2, name: TestSnowflakeServer.NodeID)
    start_link(id: 3, name: TestSnowflakeServer.Increments)

    :ok
  end

  test "get snowflake timestamp" do
    now = System.system_time(:millisecond)
    id = get_id(TestSnowflakeServer.General)
    assert_in_delta get_timestamp(id), now, 1

    now = System.system_time(:millisecond)
    :timer.sleep(10)
    id = get_id(TestSnowflakeServer.General)
    assert get_timestamp(id) > now
  end

  test "get snowflake node ID" do
    id = get_id(TestSnowflakeServer.NodeID)
    assert get_nodeid(id) == 2
  end

  test "get snowflake increment" do
    0..5
    |> Enum.map(fn i -> {i, get_id(TestSnowflakeServer.Increments)} end)
    |> Enum.each(fn {i, id} ->
      assert_in_delta get_increment(id), i, 1
    end)
  end
end
