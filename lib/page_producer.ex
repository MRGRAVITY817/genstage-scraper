defmodule PageProducer do
  use GenStage
  require Logger

  def init(initial_state) do
    Logger.info("PageProducer init")
    # buffer_size is the size of waiting list
    {:producer, initial_state, dispatcher: GenStage.DemandDispatcher}
  end

  # handle_demand(number_of_demands, producer_state)
  def handle_demand(demand, state) do
    Logger.info("Received demand for #{demand} pages")
    events = []
    {:noreply, events, state}
  end

  def scrape_pages(pages) when is_list(pages) do
    # Since now we use Broadway to handle page producer,
    # the name of page producer process is no longer __MODULE__.
    # We should use Broadway.producer_names() to find out.
    ScrapingPipeline
    |> Broadway.producer_names()
    |> List.first()
    |> GenStage.cast({:pages, pages})
  end

  def handle_cast({:pages, pages}, state) do
    {:noreply, pages, state}
  end
end
