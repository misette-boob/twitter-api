defmodule Twitter.Blog.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :body, :string
    field :title, :string
    field :number_likes, :integer, virtual: true, default: 0

    belongs_to :user, Twitter.Accounts.User
    has_many :comments, Twitter.Blog.Comment
    many_to_many :liked_by_users, Twitter.Accounts.User, join_through: "likes"

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> validate_length(:title, min: 1, max: 70)
    |> validate_length(:title, min: 1, max: 255)
  end
end
