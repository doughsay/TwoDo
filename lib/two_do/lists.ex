defmodule TwoDo.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias TwoDo.Repo

  alias TwoDo.Lists.List

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists do
    List |> order_by(:order) |> Repo.all()
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id), do: Repo.get!(List, id)

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    next_order = List |> select([l], max(l.order) + 1) |> Repo.one!()

    %List{order: next_order || 0}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  @doc """
  Sorts lists by updating the `order` field on all the lists given by the list
  of IDs.

  ## Examples

      iex> sort_lists([1, 3, 2])
      {:ok, [%List{id: 1, order: 0}, %List{id: 3, order: 1}, %List{id: 2, order: 2}]}
  """
  # Improvement opportunities:
  # * we can replace the N select queries with 1 select query but then we would
  #   have to manually cast the IDs. This is efficient enough for small
  #   use-cases like this app.
  # * we can replace the N update queries with 1 query with some clever postgres
  #   magic, but that's outside the scope of this project.
  def sort_lists!(ids) do
    {:ok, lists} =
      Repo.transaction(fn ->
        ids
        |> Enum.with_index()
        |> Enum.map(fn {id, order} ->
          list = get_list!(id)
          {:ok, list} = update_list(list, %{order: order})
          list
        end)
      end)

    lists
  end
end
