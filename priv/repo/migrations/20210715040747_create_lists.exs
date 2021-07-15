defmodule TwoDo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      timestamps()

      add :name, :text, null: false
    end
  end
end
