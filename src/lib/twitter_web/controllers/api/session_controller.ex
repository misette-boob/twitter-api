defmodule TwitterWeb.Api.SessionController do
	use TwitterWeb, :controller

	alias Twitter.Api.Accounts
	alias Twitter.Api.Guardian

	action_fallback TwitterWeb.FallbackController

	def new(conn, %{"email" => email, "password" => password}) do
		case Accounts.authenticate_user(email, password) do
			{:ok, user} -> 
				{:ok, access_token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {5, :minute})

				{:ok, refresh_token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {1, :day})

				conn
				|> put_status(:created)
				|> render("tokens.json", %{access_token: access_token, refresh_token: refresh_token})

			{:error, :unauthorized} ->
				conn
				|> put_status(:unauthorized)
				|> render("error_token.json", %{error: "unauthorized"})
		end
	end

	def refresh(conn, %{"refresh_token" => refresh_token}) do
		case Guardian.exchange(refresh_token, "refresh", "access") do
			{:ok, _old_stuff, {new_access_token, _new_claims}} ->
				conn
				|> put_status(:created)
				|> render("access_token.json", %{access_token: new_access_token})
			
			{:error, reason} ->
				conn
				|> put_status(:unauthorized)
				|> render("error_token.json", %{error: to_string(reason)})
		end
	end
end