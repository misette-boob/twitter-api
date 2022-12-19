# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twitter.Repo.insert!(%Twitter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Twitter.DatabaseSeeder do
  alias Twitter.Repo

  alias Twitter.Accounts
  alias Twitter.Accounts.User

  alias Twitter.Blog
  alias Twitter.Blog.Tweet
  alias Twitter.Blog.Comment
  alias Twitter.Blog.Like
  alias Twitter.Blog.Subscription

  alias Faker.Person
  alias Faker.Lorem
  alias Faker.Date
  alias Faker.Internet

  def clear do
    Repo.delete_all(Like)
    Repo.delete_all(Subscription)
    Repo.delete_all(Comment)
    Repo.delete_all(Tweet)
    Repo.delete_all(User)
  end

  # Users create
  def create_myself() do
    {:ok, user} = Accounts.register_user(%{
      email: "test@test.ru",
      name: "IamTestUser",
      password: "password",
      date_birth: Date.date_of_birth()
    })

    user
  end

  def create_users() do
    test_user = create_myself()

    list_users = for _i <- 1..19 do
      {:ok, user} = Accounts.register_user(%{
        email: Internet.free_email(),
        name: Person.first_name(),
        password: to_string(Lorem.characters(12)),
        date_birth: Date.date_of_birth()
      })

      user
    end

    [test_user | list_users]
  end

  # Tweets create
  def create_tweets(users) do
    list_user_tweets = for user <- users do
      number_tweets = Enum.random(1..5)

      user_tweets = if number_tweets > 0 do
        for _i <- 1..number_tweets do
          {:ok, tweet} = Blog.create_tweet(
            user,
            %{
              title: to_string(Lorem.words(1..3)),
              body: to_string(Lorem.sentence(5..25))
            }
          )

          tweet
        end
      end

      user_tweets
    end

    Enum.concat(list_user_tweets)
  end

  # Comments create
  def create_comments(users, tweets) do
    list_users_comment = for tweet <- tweets do
      number_comments = Enum.random(1..10)

      user_comments = if number_comments > 0 do
        for _i <- 1..number_comments do
          {:ok, comment} = Blog.create_comment(
            Enum.random(users),
            tweet,
            %{
              body: to_string(Lorem.sentence(5..25))
            }
          )

          comment
        end
      end

      user_comments
    end

    Enum.concat(list_users_comment)
  end

  # Suscribe create
  def create_subscriptions(users) do
    list_subscriptions = for subscriber <- users do
      number_users = Enum.count(users)
      number_subsriptions = Enum.random(1..number_users)

      future_subscriptions = for _i <- 1..number_subsriptions do
        Enum.random(users)
      end

      uniq_future_subscriptions = Enum.uniq(future_subscriptions)
      uniq_future_subscriptions_without_youself = uniq_future_subscriptions -- [subscriber]

      for subscription <- uniq_future_subscriptions_without_youself do
        {:ok, subscription} = Blog.create_subscribe(
          subscriber.id,
          subscription.id
        )

        subscription
      end
    end

    Enum.concat(list_subscriptions)
  end

  # Likes create
  def create_likes(users, tweets) do
    list_likes = for user <- users do
      number_tweets = Enum.count(tweets)
      number_likes = Enum.random(1..number_tweets)

      list_tweets = for _i <- 1..number_likes do
        Enum.random(tweets)
      end

      uniq_list_tweets = Enum.uniq(list_tweets)

      for tweet <- uniq_list_tweets do
        {:ok, like} = Blog.create_like(
          user.id,
          tweet.id
        )

        like
      end
    end

    Enum.concat(list_likes)
  end

end

Twitter.DatabaseSeeder.clear()

user_list = Twitter.DatabaseSeeder.create_users();
tweet_list = Twitter.DatabaseSeeder.create_tweets(user_list);
comment_list = Twitter.DatabaseSeeder.create_comments(user_list, tweet_list)
suscription_list = Twitter.DatabaseSeeder.create_subscriptions(user_list)
like_list = Twitter.DatabaseSeeder.create_likes(user_list, tweet_list)

:timer.sleep(2000)

IO.inspect(Enum.count(user_list), label: "Created users")
IO.inspect(Enum.count(tweet_list), label: "Created tweets")
IO.inspect(Enum.count(comment_list), label: "Created comments")
IO.inspect(Enum.count(suscription_list), label: "Created subscriptions")
IO.inspect(Enum.count(like_list), label: "Created likes")
IO.inspect(%{email: "test@test.ru", password: "password"}, label: "Test User")