defmodule Twitter.Blog.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :body, :string
    field :title, :string

    belongs_to :user, Twitter.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
