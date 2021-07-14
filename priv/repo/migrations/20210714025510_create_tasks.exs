defmodule TwoDo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      timestamps()

      add :name, :text, null: false
    end
  end
end
