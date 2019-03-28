defmodule IslandsInterface.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      {Registry, keys: :unique, name: Registry.Game},
      IslandsEngine.GameDynamicSupervisor(
      DynamicSupervisor(IslandsInterfaceWeb.Endpoint, []),
      DynamicSupervisor(IslandsInterfaceWeb.Presence, [])),
      # Starts a worker by calling: IslandsInterface.Worker.start_link(arg)
      # {IslandsInterface.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/DynamicSupervisor.html
    # for other strategies and supported options
    :ets.new(:game_state, [:public, :named_table])
    opts = [strategy: :one_for_one, name: IslandsEngine.DynamicSupervisor]
    DynamicSupervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IslandsInterfaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
