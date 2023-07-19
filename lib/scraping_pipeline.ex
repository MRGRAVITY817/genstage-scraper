defmodule ScrapingPipeline do
  use Broadway
  require Logger

  def start(_type, _args) do
    children = [
      ScrapingPipeline
    ]

    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
