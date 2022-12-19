defmodule Twitter.Blog.Like do
  use Ecto.Schema

  import Ecto.Changeset

  alias Twitter.Blog.Like

  @primary_key false

  schema "likes" do
    belongs_to :tweet, Twitter.Blog.Tweet
    belongs_to :user, Twitter.Accounts.User
  end

  def changeset(%Like{} = like, attr, _opts \\ []) do
    like
    |> cast(attr, [:tweet_id, :user_id])
    |> validate_required([:tweet_id, :user_id])
    |> foreign_key_constraint(:tweet_id)
    |> unique_constraint([:tweet_id, :user_id])
  end
end