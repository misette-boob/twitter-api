defmodule Twitter.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  import Twitter.Helper

  alias Twitter.Repo
  alias Twitter.Blog.Tweet
  alias Twitter.Blog.Comment
  alias Twitter.Blog.Like
  alias Twitter.Blog.Subscription
  alias Twitter.Accounts.User

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets(%{"user_id" => 1})
      [%Tweet{}, ...]

      iex> list_tweets(_)
      [%Tweet{}, ...]

      iex> list_tweets()
      [%Tweet{}, ...]
  """
  def list_tweets(%{"user_id" => user_id}) do
    Repo.all(from t in Tweet,
      where: t.user_id == ^user_id)
  end

  def list_tweets(_params) do
    Repo.all(Tweet)
  end

  def list_tweets do
    Repo.all(Tweet)
  end

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tweet!(id) do
    tweet = Repo.get!(Tweet, id)

    #todo Разобраться как засунуть это в схему
    number_likes = tweet
    |> Ecto.assoc(:liked_by_users)
    |> Repo.aggregate(:count, :id)

    Map.put(tweet, :number_likes, number_likes)
  end

  def get_tweet_with_comments!(id) do
    get_tweet!(id)
    |> Repo.preload(:comments)
  end

  def list_subscriptions_tweets(conn) do
    Repo.all(
      from t in Tweet,
      join: s in Subscription,
      on: t.user_id == s.subscription_id,
      where: s.subscriber_id == ^conn.assigns.current_user.id,
      select: t,
      order_by: [desc: t.inserted_at]
    )
  end

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tweet(author, attrs \\ %{}) do
    %Tweet{}
    |> Tweet.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, author)
    |> Repo.insert()
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{data: %Tweet{}}

  """
  def change_tweet(%Tweet{} = tweet, attrs \\ %{}) do
    Tweet.changeset(tweet, attrs)
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments(%{"tweet_id" => 1})
      [%Comment{}, ...]

      iex> list_comments(_)
      [%Comment{}, ...]

  """
  def list_comments(%{"tweet_id" => tweet_id}) do
    Repo.all(from t in Comment,
      where: t.tweet_id == ^tweet_id)
  end

  def list_comments(_params) do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  def get_comment(id), do: Repo.get(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(%User{} = author, %Tweet{} = tweet, attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tweet, tweet)
    |> Ecto.Changeset.put_assoc(:user, author)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def tweet_like(conn, tweet_id) do
    %Like{}
    |> Like.changeset(%{
        tweet_id: maybe_to_int(tweet_id),
        user_id: conn.assigns.current_user.id
      })
    |> Repo.insert()
  end

  def tweet_dislike(conn, tweet_id) do
    Repo.delete_all(from l in Like,
      where: l.tweet_id == ^maybe_to_int(tweet_id) and l.user_id == ^conn.assigns.current_user.id)
  end

  def list_liked_tweets(conn) do
    current_user = conn.assigns.current_user
    |> Repo.preload(:liked_tweets)

    current_user.liked_tweets
  end

  def subscribe(conn, user_id) do
    %Subscription{}
    |> Subscription.changeset(%{
        subscription_id: maybe_to_int(user_id),
        subscriber_id: conn.assigns.current_user.id
      })
    |> Repo.insert()
  end

  def unsubscribe(conn, user_id) do
    Repo.delete_all(from l in Subscription,
      where: l.subscription_id == ^maybe_to_int(user_id) and l.subscriber_id == ^conn.assigns.current_user.id)
  end
end
