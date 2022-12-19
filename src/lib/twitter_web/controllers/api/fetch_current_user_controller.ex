defmodule Twitter.Plugs.FetchCurrentUser do
  alias Twitter.Api.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    current_token = Guardian.Plug.current_token(conn)
    case Guardian.resource_from_token(current_token) do
      {:ok, user, _claims} ->
        Plug.Conn.assign(conn, :current_user, user)
      {:error, _reason} ->
        conn
    end
  end
end