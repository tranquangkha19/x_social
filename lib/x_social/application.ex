defmodule XSocial.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      XSocialWeb.Telemetry,
      XSocial.Repo,
      {DNSCluster, query: Application.get_env(:x_social, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: XSocial.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: XSocial.Finch},
      # Start a worker by calling: XSocial.Worker.start_link(arg)
      # {XSocial.Worker, arg},
      # Start to serve requests, typically the last entry
      XSocialWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XSocial.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XSocialWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
