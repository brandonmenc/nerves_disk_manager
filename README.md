# NervesDiskManager

Monitors and reports changes to the disks attached to a
[Nerves](https://nerves-project.org/) device.

## Installation

The package can be installed by adding `nerves_disk_manager` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nerves_disk_manager, git: "https://github.com/brandonmenc/nerves_disk_manager"}
  ]
end
```

## Example

[NervesDiskMountExample](https://github.com/brandonmenc/nerves_disk_mount_example)
is an example app that uses this module.

## Todo

Lots. Not production ready.

## See also

[NervesMountManager](https://github.com/brandonmenc/nerves_mount_manager)

## How it works

`NervesDiskManager.DiskWatcher` waits for block device changes in
`SystemRegistry`.

```elixir
iex> SystemRegistry.match(:_) |> get_in([:state, "subsystems", "block"])
```

SCSI disk device partitions (ex: a USB flash drive partition at /dev/sda1 ) are
filtered out and their states are tracked. Three lists of disk partitions are
maintained:

```elixir
iex> SystemRegistry.match(:_) |> get_in([:state, :disks]) |> Map.keys()
[:added, :partitions, :removed]
```

`:partitions` is a list of all the currently connected partitions. `:added` is a
subset of `:partitions` - a list of all the partitions that were connected since
the last time the state was updated. `:removed` is a list of all the partitions
that were disconnected since the last time the state was updated. The format of
the entries in `:added` and `:removed` is the same as in `:partitions`.

Let's say a USB drive was just plugged in:

```elixir
iex> SystemRegistry.match(:_) |> get_in([:state, :disks])
%{added: ["sda1"], partitions: ["sda1"], removed: []}
```

Sometimes you just want to check `:partitions` for a specific disk partition,
but you can also build more complex logic based on the `:added` and `:removed`
lists.
