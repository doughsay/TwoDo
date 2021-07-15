defmodule TwoDoWeb.TaskLive.Show do
  use TwoDoWeb, :live_view

  alias TwoDo.{Lists, Tasks}

  @impl true
  def mount(%{"list_id" => list_id}, _session, socket) do
    list = Lists.get_list!(list_id)

    {:ok, assign(socket, :list, list)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:task, Tasks.get_task!(id))}
  end

  defp page_title(:show), do: "Show Task"
  defp page_title(:edit), do: "Edit Task"
end
