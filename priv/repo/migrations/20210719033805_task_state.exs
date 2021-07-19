defmodule TwoDo.Repo.Migrations.TaskState do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :state, :text, default: "new", null: false
    end
  end
end
