defmodule Twitter.Api.Accounts do
  @moduledoc """
  The API context.
  """

  alias Twitter.Accounts

  def get_user_by_email(email) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_user!(id) do
    Accounts.get_user!(id)
  end

  def authenticate_user(email, password) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil -> {:error, :unauthorized}
      user -> {:ok, user}
    end
  end

  def update_user(user, user_params) do
    Accounts.update_user_data(user, user_params)
  end

end
