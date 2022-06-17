defmodule PhoenixDatadog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    SpandexPhoenix.Telemetry.install()

    children = [
      {SpandexDatadog.ApiServer, datadog_opts()},
      # Start the Ecto repository
      # PhoenixDatadog.Repo,
      # Start the Telemetry supervisor
      PhoenixDatadogWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixDatadog.PubSub},
      # Start the Endpoint (http/https)
      PhoenixDatadogWeb.Endpoint
      # Start a worker by calling: PhoenixDatadog.Worker.start_link(arg)
      # {PhoenixDatadog.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixDatadog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp datadog_opts do
    [
      host: System.get_env("DATADOG_HOST") || "localhost",
      port: System.get_env("DATADOG_PORT") || 8126,
      batch_size: String.to_integer(System.get_env("SPANDEX_BATCH_SIZE") || "1"),
      sync_threshold: String.to_integer(System.get_env("SPANDEX_SYNC_THRESHOLD") || "20"),
      verbose?: true,
      # http: HTTPoison
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixDatadogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
