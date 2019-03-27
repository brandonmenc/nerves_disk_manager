defmodule NervesDiskManager.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :nerves_disk_manager,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/brandonmenc/nerves_disk_manager",
      homepage_url: "https://github.com/brandonmenc/nerves_disk_manager",
      name: "Nerves Disk Manager",
      description: """
      Monitors the disks connected to a Nerves device.
      """
    ]
  end

  def application do
    [
      mod: {NervesDiskManager.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
    ]
  end

  defp package do
    [
      maintainers: ["Brandon Menc"],
      licenses: ["Apache-2.0"],
      links: %{github: "https://github.com/brandonmenc/nerves_disk_manager"}
    ]
  end
end
