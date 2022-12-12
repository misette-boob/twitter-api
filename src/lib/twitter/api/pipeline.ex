defmodule Twitter.Api.Guardian.AuthPipeline do
	@claims %{typ: "access"}

	use Guardian.Plug.Pipeline,
		otp_app: :twitter,
		module: Twitter.Api.Guardian,
		error_handler: Twitter.Api.Guardian.AuthErrorHandler

	plug(Guardian.Plug.VerifyHeader, claims: @claims, scheme: "Bearer")
	plug(Guardian.Plug.EnsureAuthenticated)
	plug(Guardian.Plug.LoadResource, ensure: true)
end