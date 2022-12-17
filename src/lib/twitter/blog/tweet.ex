defmodule Twitter.Blog.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :body, :string
    field :title, :string

    belongs_to :user, Twitter.Accounts.User
    has_many :comments, Twitter.Blog.Comment

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
