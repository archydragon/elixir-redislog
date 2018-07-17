defmodule Redislog.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/archydragon/elixir-redislog"

  def project do
    [
      app: :redislog,
      version: @version,
      elixir: "~> 1.4",
      source_url: @url,
      homepage_url: @url,
      description: "Redis pubsub backend for standard logger",
      package: package(),
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [
      applications: [:logger, :poison, :redix]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:redix, ">= 0.0.0"}
    ]
  end

  defp package do
    [
      name: :redislog,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nikita K. <mendor@yuuzukiyo.net>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @url
      }
    ]
  end
end
