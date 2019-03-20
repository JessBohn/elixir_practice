defmodule IslandsEngine.Game do
  use GenServer
  alias IslandsEngine.{Board, Coordinate, Guesses, Island, Rules}
  @players [:player1, :player2]

  def handle_info(:first, state) do
    IO.puts "This message has been handled by handle_info/2, matching on :first."
    {:noreply, state}
  end

  def handle_call(:demo_call, _from, state) do
    {:reply, state, state}
  end
  def handle_call({:add_player, name}, _from, state_data) do
    with {:ok, rules} <- Rules.check(state_data.rules, :add_player)
    do
      state_data
      |> update_player2_name(name)
      |> update_rules
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state_data}
    end
  end
  def handle_call({:position_island, player, key, row, col}, _from, state_data) do
    board = player_board(state_data, player)
    with {:ok, rules} <- Rules.check(state_data.rules, {:position_islands, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         {:ok, island} <- Island.new(key, coordinate),
         %{} = board <- Board.position_island(board, key, island)
    do
      state_data
      |> update_board(player, board)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state_data}
      {:error, :invalid_coordinate} -> {:reply, {:error, :invalid_coordinate}, state_data}
      {:error, :invalid_island_type} -> {:reply, {:error, :invalid_island_type}, state_data}
    end
  end
  def handle_call({:set_islands, player}, _from, state_data) do
    board = player_board(state_data, player)
    with {:ok, rules} <- Rules.check(state_data.rules, {:set_islands, player}),
         true <- Board.all_islands_positioned?(board)
    do
      state_data
      |> update_rules(rules)
      |> reply_success({:ok, board})
    else
      :error -> {:reply, :error, state_data}
      false -> {:reply, {:error, :not_all_islands_positioned}, state_data}
    end
  end

  def demo_call(game) do
    GenServer.call(game, :demo_call)
  end

  def handle_cast({:demo_cast, new_value}, state) do
    {:noreply, Map.put(state, :test, new_value)}
  end

  def demo_cast(pid, new_value) do
    GenServer.cast(pid, {:demo_cast, new_value})
  end

  def start_link(name) when is_binary(name), do: GenServer.start_link(__MODULE__, name, [])

  def init(name) do
    player1 = %{name: name, board: Board.new(), guesses: Guesses.new()}
    player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}
    {:ok, %{player1: player1, player2: player2, rules: %Rulers{}}}
  end

  def add_player(game, name) when is_binary(name), do: GenServer.call(game, {:add_player, name})

  defp update_player2_name(state_data, name), do: put_in(state_data.player2.name, name)
  defp update_rules(state_data, rules), do: %{state_data | rules: rules}
  defp reply_success(state_data, reply), do: {:reply, reply, state_data}

  def position_island(game, player, key, row, col) when player in @players, do: GenServer.call(game, {:position_island, player, key, row, col})
  defp player_board(state_data, player), do: Map.get(state_data, player).board

  def set_islands(game, player) when player in @players, do: GenServer.call(game, {:set_islands, player})

end