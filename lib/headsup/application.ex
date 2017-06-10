defmodule Headsup.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Headsup.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Headsup.Web.Endpoint, []),
      # Start your own worker by calling: Headsup.Worker.start_link(arg1, arg2, arg3)
      # worker(Headsup.Worker, [arg1, arg2, arg3]),
      supervisor(Headsup.Matches.StatusSupervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Headsup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
