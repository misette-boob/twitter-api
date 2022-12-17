defmodule Twitter.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Twitter.Repo

  alias Twitter.Blog.Tweet
  alias Twitter.Accounts.User
  alias Twitter.Blog.Comment

  @doc """
  Returns the list of tweets by user.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  def list_tweets(%{"user_id" => user_id}) do
    Repo.all(from t in Tweet,
      where: t.user_id == ^user_id)
  end

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
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
  def get_tweet!(id), do: Repo.get!(Tweet, id)

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
  Returns the list of comments by tweet.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments(%{"tweet_id" => tweet_id}) do
    Repo.all(from t in Comment,
      where: t.tweet_id == ^tweet_id)
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
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
end
