# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phoenix_datadog,
  ecto_repos: [PhoenixDatadog.Repo]

# Configures the endpoint
config :phoenix_datadog, PhoenixDatadogWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PhoenixDatadogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhoenixDatadog.PubSub,
  live_view: [signing_salt: "upWfOuZ+"]
  # This is not needed with the new telemetry support in Phoenix
  # instrumenters: [SpandexPhoenix.Instrumenter]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :phoenix_datadog, PhoenixDatadog.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  # Add Datadog trace_id and span_id to log messages for correllation
  metadata: [:request_id, :trace_id, :span_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_datadog, PhoenixDatadog.Tracer,
  adapter: SpandexDatadog.Adapter,
  # disabled?: true,
  env: "development",
  service: :phoenix_datadog

config :spandex_phoenix, tracer: PhoenixDatadog.Tracer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
