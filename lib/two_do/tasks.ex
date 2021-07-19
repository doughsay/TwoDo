defmodule TwoDo.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TwoDo.Repo

  alias TwoDo.Lists.List
  alias TwoDo.Tasks.Task

  @doc """
  Returns the list of tasks for a given list.

  ## Examples

      iex> list_tasks(%List{})
      [%Task{}, ...]

  """
  def list_tasks(%List{id: list_id}) do
    Task
    |> where(list_id: ^list_id)
    |> order_by(:order)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task for the given list.

  ## Examples

      iex> create_task(%List{}, %{field: value})
      {:ok, %Task{}}

      iex> create_task(%List{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(%List{id: list_id}, attrs \\ %{}) do
    next_order =
      Task
      |> select([t], max(t.order) + 1)
      |> where(list_id: ^list_id)
      |> Repo.one!()

    %Task{list_id: list_id, order: next_order || 0}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Sorts tasks by updating the `order` field on all the tasks given by the list
  of IDs.

  ## Examples

      iex> sort_tasks([1, 3, 2])
      {:ok, [%Task{id: 1, order: 0}, %Task{id: 3, order: 1}, %Task{id: 2, order: 2}]}
  """
  # Improvement opportunities:
  # * we can replace the N select queries with 1 select query but then we would
  #   have to manually cast the IDs. This is efficient enough for small
  #   use-cases like this app.
  # * we can replace the N update queries with 1 query with some clever postgres
  #   magic, but that's outside the scope of this project.
  def sort_tasks!(ids) do
    {:ok, tasks} =
      Repo.transaction(fn ->
        ids
        |> Enum.with_index()
        |> Enum.map(fn {id, order} ->
          task = get_task!(id)
          {:ok, task} = update_task(task, %{order: order})
          task
        end)
      end)

    tasks
  end
end
