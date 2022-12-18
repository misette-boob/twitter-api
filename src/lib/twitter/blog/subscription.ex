defmodule Twitter.Blog.Subscription do
  use Ecto.Schema

  import Ecto.Changeset

  alias Twitter.Blog.Subscription

  @primary_key false

  schema "subscriptions" do
    belongs_to :subscription, Twitter.Accounts.User
    belongs_to :subscriber, Twitter.Accounts.User
  end

  @doc false
  def changeset(%Subscription{} = subscription, attr, _opts \\ []) do
    subscription
    |> cast(attr, [:subscription_id, :subscriber_id])
    |> validate_required([:subscription_id, :subscriber_id])
    |> foreign_key_constraint(:subscription_id)
    |> unique_constraint([:subscription_id, :subscriber_id], name: :subscription_subscriber_index)
    |> unique_constraint([:subscriber_id, :subscription_id], name: :subscriber_subscription_index)
    |> validate_subscribe_yourself()
  end

  def validate_subscribe_yourself(changeset) do
    if get_field(changeset, :subscription_id) != get_field(changeset, :subscriber_id) do
      changeset
    else
      add_error(changeset, :subscription_id, "you can't subscribe to yourself")
    end
  end
end