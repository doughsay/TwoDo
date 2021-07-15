defmodule TwoDo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias TwoDo.Lists.List

  schema "tasks" do
    belongs_to :list, List

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
