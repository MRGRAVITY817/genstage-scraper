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

  def start_link(_args) do
    options = [
      name: ScrapingPipeline,
      producer: [
        module: {PageProducer, []},
        transformer: [ScrapingPipeline, :transform, []]
      ],
      processors: [
        default: []
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end
end
