defmodule Dingen.Mixfile do
  use Mix.Project

  def project do
    [app: :dingen,
     version: "0.1.0",
     elixir: "~> 1.3",
     erlc_paths: ["lib"], # let erlang know to use "lib" instead of "src" to look for files to compile
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy],
     mod: {Dingen, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0.4"},
    ]
  end
end
