defmodule TwoDo.TasksTest do
  use TwoDo.DataCase

  alias TwoDo.{Lists, Tasks}

  setup do
    {:ok, list} = Lists.create_list(%{name: "Test List"})

    {:ok, list: list}
  end

  describe "tasks" do
    alias TwoDo.Tasks.Task

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def task_fixture(list, attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> (&Tasks.create_task(list, &1)).()

      task
    end

    test "list_tasks/0 returns all tasks", context do
      %{list: list} = context

      task = task_fixture(list)
      assert Tasks.list_tasks(list) == [task]
    end

    test "get_task!/1 returns the task with given id", context do
      %{list: list} = context

      task = task_fixture(list)
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task", context do
      %{list: list} = context

      assert {:ok, %Task{} = task} = Tasks.create_task(list, @valid_attrs)
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset", context do
      %{list: list} = context

      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(list, @invalid_attrs)
    end

    test "update_task/2 with valid data updates the task", context do
      %{list: list} = context

      task = task_fixture(list)
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset", context do
      %{list: list} = context

      task = task_fixture(list)
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task", context do
      %{list: list} = context

      task = task_fixture(list)
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset", context do
      %{list: list} = context

      task = task_fixture(list)
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end

    test "sort_tasks/1 sorts tasks", context do
      %{list: list} = context

      [%{id: task1}, %{id: task2}, %{id: task3}] = [
        task_fixture(list),
        task_fixture(list),
        task_fixture(list)
      ]

      assert tasks = Tasks.sort_tasks!([task1, task3, task2])
      assert [{^task1, 0}, {^task3, 1}, {^task2, 2}] = Enum.map(tasks, &{&1.id, &1.order})
    end
  end
end
