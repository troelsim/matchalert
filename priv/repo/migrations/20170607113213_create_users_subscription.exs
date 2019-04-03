defmodule Matchalert.Repo.Migrations.CreateMatchalert.Users.Subscription do
  use Ecto.Migration

  def change do
    create table(:users_subscriptions) do
      add :email, :string

      timestamps()
    end

  end
end
