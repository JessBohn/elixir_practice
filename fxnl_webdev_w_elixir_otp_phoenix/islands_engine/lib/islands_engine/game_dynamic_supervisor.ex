defmodule IslandsEngine.GameDynamicSupervisor do
  use DynamicSupervisor
  alias IslandsEngine.Game

  def start_link(_options), do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: DynamicSupervisor.init([Game], strategy: :_one_for_one)

  def start_game(name), do: DynamicSupervisor.start_child(__MODULE__, [name])

  def stop_game(name) do
    :ets.delete(:game_state, name)
    DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(name))
  end

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end
