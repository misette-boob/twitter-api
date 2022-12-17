defmodule Twitter.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :tweet_id, references(:tweets, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:tweet_id])
  end
end
