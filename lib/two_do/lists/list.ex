defmodule TwoDo.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :name, :string
    field :order, :integer

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name, :order])
    |> validate_required([:name, :order])
  end
end
