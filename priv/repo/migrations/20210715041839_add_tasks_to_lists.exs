defmodule TwoDo.Repo.Migrations.AddTasksToLists do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :list_id, references(:lists, on_delete: :delete_all), null: false
    end
  end
end
