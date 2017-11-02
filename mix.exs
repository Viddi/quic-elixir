defmodule QUIC.Mixfile do
  use Mix.Project

  def project do
    [
      app: :quic,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      dialyzer: [
        flags: [:error_handling, :race_conditions, :underspecs],
        paths: ["_build/dev/lib/quic/ebin"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18.1"},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:credo, "~> 0.8.8", only: [:dev, :test], runtime: false}
    ]
  end
end
