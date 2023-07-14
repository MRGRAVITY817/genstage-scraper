defmodule Scraper.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # the process starts in this order
    children = [
      PageProducer,
      PageConsumerSupervisor,
      # Since we have to find PageConsumerSupervisors pid,
      # OnlinePageProducerConsumer should come after.
      OnlinePageProducerConsumer
    ]

    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def producer_consumer_spec(id: id) do
    id = "online_page_producer_consumer_#{id}"
    Supervisor.child_spec({OnlinePageProducerConsumer, id}, id: id)
  end
end
