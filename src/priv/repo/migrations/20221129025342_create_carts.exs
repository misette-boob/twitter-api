defmodule Twitter.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :user_uuid, :uuid

      timestamps()
    end

    create unique_index(:carts, [:user_uuid])
  end
end
