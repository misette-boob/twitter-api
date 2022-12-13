defmodule TwitterWeb.Api.SessionView do
	use TwitterWeb, :view

	def render("tokens.json", %{access_token: access_token, refresh_token: refresh_token}) do
		%{access_token: access_token, refresh_token: refresh_token}
	end

	def render("access_token.json", %{access_token: access_token}) do
		%{access_token: access_token}
	end

	def render("error_token.json", %{error: message}) do
		%{error: message}
	end
end