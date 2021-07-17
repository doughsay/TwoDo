defmodule TwoDoWeb.TaskLive.ShowComponent do
  use TwoDoWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
