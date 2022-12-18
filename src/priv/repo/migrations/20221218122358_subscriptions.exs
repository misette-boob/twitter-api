defmodule Twitter.Repo.Migrations.Subscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :subscription_id, references(:users, on_delete: :delete_all)
      add :subscriber_id, references(:users, on_delete: :delete_all)
    end

    create index(:subscriptions, [:subscription_id])
    create index(:subscriptions, [:subscriber_id])

    create unique_index(
      :subscriptions,
      [:subscription_id, :subscriber_id],
      name: :subscription_subscriber_index
    )

    create unique_index(
      :subscriptions,
      [:subscriber_id, :subscription_id],
      name: :subscriber_subscription_index
    )
  end
end
