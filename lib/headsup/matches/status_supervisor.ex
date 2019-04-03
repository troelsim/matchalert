defmodule Matchalert.Matches.StatusSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Matchalert.Matches.Status, [Matchalert.Matches.Status])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
