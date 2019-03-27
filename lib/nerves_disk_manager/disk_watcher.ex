defmodule NervesDiskManager.DiskWatcher do
  use GenServer
  require Logger

  @partition_regex ~r/(?<partition>sd[a-z]+[0-1]+)/

  defmodule State do
    defstruct partitions: []
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    partitions =
      SystemRegistry.match(:_)
      |> get_partitions()

    update_registry(partitions)

    SystemRegistry.register()

    {:ok, %State{partitions: partitions}}
  end

  def handle_info({:system_registry, :global, registry}, %State{} = state) do
    partitions = get_partitions(registry)

    if (partitions != state.partitions) do
      update_registry(partitions, state.partitions)
    end

    {:noreply, %{state | partitions: partitions}}
  end

  def update_registry(partitions, old_partitions \\ []) do
    SystemRegistry.update([:state, :disks], %{
      partitions: partitions,
      added: partitions -- old_partitions,
      removed: old_partitions -- partitions
    })
  end

  def get_partitions(registry) do
    registry
    |> get_block_devices()
    |> Enum.map(&List.last/1)
    |> Enum.filter(&partition?/1)
  end

  def get_block_devices(registry) do
    get_in(registry, [:state, "subsystems", "block"]) || []
  end

  def partition?(string) do
    Regex.match?(@partition_regex, string)
  end
end
