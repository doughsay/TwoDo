defmodule TwoDoWeb.ListLiveTest do
  use TwoDoWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TwoDo.Lists

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:list) do
    {:ok, list} = Lists.create_list(@create_attrs)
    list
  end

  defp create_list(_) do
    list = fixture(:list)
    %{list: list}
  end

  describe "Index" do
    setup [:create_list]

    test "lists all lists", %{conn: conn, list: list} do
      {:ok, _index_live, html} = live(conn, Routes.list_index_path(conn, :index))

      assert html =~ list.name
    end

    test "saves new list", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      assert index_live |> element("a", "New") |> render_click() =~
               "New List"

      assert_patch(index_live, Routes.list_index_path(conn, :new))

      assert index_live
             |> form("#list-form", list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#list-form", list: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.list_index_path(conn, :index))

      assert html =~ "List created successfully"
      assert html =~ "some name"
    end

    test "updates list in listing", %{conn: conn, list: list} do
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      assert index_live |> element("#list-#{list.id} a", "Edit") |> render_click() =~
               "Edit List"

      assert_patch(index_live, Routes.list_index_path(conn, :edit, list))

      assert index_live
             |> form("#list-form", list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#list-form", list: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.list_index_path(conn, :index))

      assert html =~ "List updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes list in listing", %{conn: conn, list: list} do
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      assert index_live |> element("#list-#{list.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#list-#{list.id}")
    end
  end
end
