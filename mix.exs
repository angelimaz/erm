defmodule Erm.MixProject do
  use Mix.Project

  def project do
    [
      app: :erm,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Erm.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ueberauth, "~> 0.5.0"},
      {:ueberauth_identity, "~> 0.2.3"},
      {:guardian, "~> 1.1.1"},
      {:comeonin, "~> 4.1"},
      {:bcrypt_elixir, "~> 1.0"},
      {:ueberauth_linkedin, "~> 0.3"},
      {:ueberauth_github, "~> 0.7"},
      {:ueberauth_facebook, "~> 0.7"},
      {:ueberauth_microsoft, "~> 0.4"},
      {:geo_postgis, "~> 2.0"},
      {:geo, "~> 3.0"},
      {:httpoison, "~> 1.4"},
      {:httpotion, "~> 3.1.0"},
      {:tesla, "~> 1.2.1"},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end