defmodule CondParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :cond_parser,
      version: "1.0.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "CondParser",
      description: "Condition parser",
      package: package(),
      source_url: "https://github.com/FabienHenon/cond_parser",
      homepage_url: "https://github.com/FabienHenon/cond_parser",
      docs: [
        main: "CondParser",
        extras: ["README.md"]
      ]
    ]
  end

  def package() do
    [
      name: "cond_parser",
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/FabienHenon/cond_parser"}
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
