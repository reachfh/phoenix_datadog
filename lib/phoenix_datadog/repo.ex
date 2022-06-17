defmodule PhoenixDatadog.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_datadog,
    adapter: Ecto.Adapters.Postgres
end
