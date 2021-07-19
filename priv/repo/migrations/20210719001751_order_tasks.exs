defmodule TwoDo.Repo.Migrations.OrderTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :order, :integer
    end
  end
end
