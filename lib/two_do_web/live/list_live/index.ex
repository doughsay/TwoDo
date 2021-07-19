defmodule TwoDoWeb.ListLive.Index do
  use TwoDoWeb, :live_view

  alias TwoDo.Lists
  alias TwoDo.Lists.List
  alias TwoDo.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: PubSub.subscribe("lists")

    {:ok,
     socket
     |> assign(:lists, Lists.list_lists())
     |> assign(:layout_add_url, Routes.list_index_path(socket, :new))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Lists.get_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Lists.get_list!(id)
    {:ok, _} = Lists.delete_list(list)

    {:noreply, assign(socket, :lists, Lists.list_lists())}
  end

  def handle_event("sort", %{"ids" => ids}, socket) do
    lists = Lists.sort_lists!(ids)

    {:noreply, assign(socket, :lists, lists)}
  end

  @impl true
  def handle_info(:lists_updated, socket) do
    {:noreply, assign(socket, :lists, Lists.list_lists())}
  end
end
