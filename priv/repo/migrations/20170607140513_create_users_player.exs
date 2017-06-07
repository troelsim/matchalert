defmodule Headsup.Repo.Migrations.CreateHeadsup.Users.Player do
  use Ecto.Migration

  def change do
    create table(:users_players) do
      add :name, :string

      timestamps()
    end

    create unique_index(:users_players, [:name])
  end
end
