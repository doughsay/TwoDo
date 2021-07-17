defmodule TwoDoWeb.TaskLiveTest do
  use TwoDoWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TwoDo.{Lists, Tasks}

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(schema, opts \\ %{})

  defp fixture(:list, _opts) do
    {:ok, list} = Lists.create_list(@create_attrs)
    list
  end

  defp fixture(:task, %{list: list}) do
    {:ok, task} = Tasks.create_task(list, @create_attrs)
    task
  end

  defp create_task(_) do
    list = fixture(:list)
    task = fixture(:task, %{list: list})
    %{list: list, task: task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all tasks", %{conn: conn, list: list, task: task} do
      {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index, list))

      assert html =~ "Listing Tasks"
      assert html =~ task.name
    end

    test "shows task in modal", %{conn: conn, list: list, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, list))

      assert index_live |> element("#task-#{task.id} a", "Show") |> render_click() =~
               "Show Task"

      assert_patch(index_live, Routes.task_index_path(conn, :show, list, task))
    end

    test "saves new task", %{conn: conn, list: list} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, list))

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, Routes.task_index_path(conn, :new, list))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index, list))

      assert html =~ "Task created successfully"
      assert html =~ "some name"
    end

    test "updates task in listing", %{conn: conn, list: list, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, list))

      assert index_live |> element("#task-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, Routes.task_index_path(conn, :edit, list, task))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index, list))

      assert html =~ "Task updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes task in listing", %{conn: conn, list: list, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, list))

      assert index_live |> element("#task-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end
end
