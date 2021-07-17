defmodule TwoDoWeb.TaskLive.Index do
  use TwoDoWeb, :live_view

  alias TwoDo.{Lists, Tasks}
  alias TwoDo.Tasks.Task

  @impl true
  def mount(%{"list_id" => list_id}, _session, socket) do
    list = Lists.get_list!(list_id)

    {:ok,
     socket
     |> assign(:tasks, Tasks.list_tasks(list))
     |> assign(:list, list)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, assign(socket, :tasks, Tasks.list_tasks(socket.assigns.list))}
  end
end
