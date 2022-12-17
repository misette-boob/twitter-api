defmodule Twitter.BlogTest do
  use Twitter.DataCase

  alias Twitter.Blog

  describe "tweets" do
    alias Twitter.Blog.Tweet

    import Twitter.BlogFixtures

    @invalid_attrs %{body: nil, title: nil}

    test "list_tweets/0 returns all tweets" do
      tweet = tweet_fixture()
      assert Blog.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      assert Blog.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      valid_attrs = %{body: "some body", title: "some title"}

      assert {:ok, %Tweet{} = tweet} = Blog.create_tweet(valid_attrs)
      assert tweet.body == "some body"
      assert tweet.title == "some title"
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = tweet_fixture()
      update_attrs = %{body: "some updated body", title: "some updated title"}

      assert {:ok, %Tweet{} = tweet} = Blog.update_tweet(tweet, update_attrs)
      assert tweet.body == "some updated body"
      assert tweet.title == "some updated title"
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_tweet(tweet, @invalid_attrs)
      assert tweet == Blog.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Blog.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Blog.change_tweet(tweet)
    end
  end

  describe "comments" do
    alias Twitter.Blog.Comment

    import Twitter.BlogFixtures

    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Blog.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Blog.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %Comment{} = comment} = Blog.create_comment(valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Blog.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_comment(comment, @invalid_attrs)
      assert comment == Blog.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Blog.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Blog.change_comment(comment)
    end
  end
end
