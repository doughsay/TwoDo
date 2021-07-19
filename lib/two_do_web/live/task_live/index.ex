defmodule TwoDoWeb.TaskLive.Index do
  use TwoDoWeb, :live_view

  alias TwoDo.Lists
  alias TwoDo.PubSub
  alias TwoDo.Tasks
  alias TwoDo.Tasks.Task

  @impl true
  def mount(%{"list_id" => list_id}, _session, socket) do
    list = Lists.get_list!(list_id)

    if connected?(socket), do: PubSub.subscribe("lists:#{list.id}")

    {:ok,
     socket
     |> assign(:tasks, Tasks.list_tasks(list))
     |> assign(:list, list)
     |> assign(:keyboard_selected_task_id, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
  def handle_event("sort", %{"ids" => ids}, socket) do
    tasks = Tasks.sort_tasks!(socket.assigns.list, ids)

    {:noreply, assign(socket, :tasks, tasks)}
  end

  def handle_event("toggle", %{"task" => task_id}, socket) do
    task = Tasks.get_task!(task_id)
    socket = toggle_task(task, socket)

    {:noreply, socket}
  end

  def handle_event("shortcut", %{"key" => key}, socket) do
    socket = handle_keyboard_shortcut(key, socket.assigns.live_action, socket)

    {:noreply, socket}
  end

  defp toggle_task(task, socket) do
    case task.state do
      :new -> Tasks.complete_task!(task)
      :done -> Tasks.mark_new!(task)
    end

    assign(socket, :tasks, Tasks.list_tasks(socket.assigns.list))
  end

  @impl true
  def handle_info(:tasks_updated, socket) do
    {:noreply, assign(socket, :tasks, Tasks.list_tasks(socket.assigns.list))}
  end

  defp handle_keyboard_shortcut(key, :index, socket) when key in ~w(n N) do
    push_patch(socket, to: Routes.task_index_path(socket, :new, socket.assigns.list))
  end

  defp handle_keyboard_shortcut("Backspace", :index, socket) do
    push_redirect(socket, to: Routes.list_index_path(socket, :index))
  end

  defp handle_keyboard_shortcut(".", :index, socket) do
    select_next(socket)
  end

  defp handle_keyboard_shortcut(",", :index, socket) do
    select_next(socket, -1)
  end

  defp handle_keyboard_shortcut(">", :index, socket) do
    socket
  end

  defp handle_keyboard_shortcut("<", :index, socket) do
    socket
  end

  defp handle_keyboard_shortcut(key, :index, socket) when key in ["x", "X", " "] do
    if task_id = socket.assigns.keyboard_selected_task_id do
      task = Tasks.get_task!(task_id)
      toggle_task(task, socket)
    else
      socket
    end
  end

  defp handle_keyboard_shortcut(key, :index, socket) when key in ~w(e E Enter) do
    if task_id = socket.assigns.keyboard_selected_task_id do
      push_patch(socket, to: Routes.task_index_path(socket, :edit, socket.assigns.list, task_id))
    else
      socket
    end
  end

  defp handle_keyboard_shortcut(_key, _action, socket) do
    socket
  end

  defp select_next(socket, direction \\ 1) do
    if task_id = socket.assigns.keyboard_selected_task_id do
      idx = Enum.find_index(socket.assigns.tasks, &(&1.id == task_id))
      idx = rem(idx + direction, length(socket.assigns.tasks))
      task = Enum.at(socket.assigns.tasks, idx)
      assign(socket, :keyboard_selected_task_id, task.id)
    else
      id =
        case socket.assigns.tasks do
          [] -> nil
          [task | _] -> task.id
        end

      assign(socket, :keyboard_selected_task_id, id)
    end
  end
end
