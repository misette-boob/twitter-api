defmodule Twitter.Repo.Migrations.Likes do
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add :tweet_id, references(:tweets, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:likes, [:user_id])
    create index(:likes, [:tweet_id])
    create unique_index(:likes, [:tweet_id, :user_id])
  end
end
