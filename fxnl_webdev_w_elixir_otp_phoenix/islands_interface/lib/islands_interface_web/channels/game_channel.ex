defmodule IslandsInterfaceWeb.GameChannel do
  use IslandsInterfaceWeb, :channel
  alias IslandsEngine.{Game, GameSupervisor}

  def channel do
    quote do
      use Phoenix.Channel
      import IslandsInterfaceWeb.Gettext
    end
  end

  def join("game:" <> _player, parameters, socket) do
    {:ok, socket}
  end

  def handle_in("hello", payload, socket) do
    broadcast! socket, "said_hello", payload
    {:noreply, socket}
  end
end
