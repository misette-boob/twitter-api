defmodule Twitter.Api.Accounts do
  @moduledoc """
  The API context.
  """

  alias Twitter.Repo
  alias Twitter.Accounts
  alias Twitter.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Accounts.get_user!(id)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def authenticate_user(email, password) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil -> {:error, :unauthorized}
      user -> {:ok, user}
    end
  end

  @doc """
  Update user fields except email and password

  ## Examples

      iex> update_user_data(user, %{name: ...})
      {:ok, %User{}}

      iex> update_user_data(user, %{name: ...})
      {
  """
  def update_user(user, user_params) do
    Accounts.update_user_data(user, user_params)
  end

  def create_user(user_params) do
    Accounts.register_user(user_params)
  end

end
