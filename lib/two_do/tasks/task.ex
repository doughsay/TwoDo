defmodule TwoDo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias TwoDo.Lists.List

  schema "tasks" do
    belongs_to :list, List

    field :name, :string
    field :order, :integer
    field :state, Ecto.Enum, values: [:new, :done, :archived], default: :new

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :order, :state])
    |> validate_required([:name, :order, :state])
  end
end
