defmodule NervesDiskManager.Application do
  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: NervesDiskManager.Supervisor]

    Supervisor.start_link([NervesDiskManager.DiskWatcher], opts)
  end
end
