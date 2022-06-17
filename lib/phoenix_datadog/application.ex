defmodule PhoenixDatadog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PhoenixDatadog.Repo,
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

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixDatadogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
