defmodule PageProducer do
  use GenStage
  require Logger

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    Logger.info("PageProducer init")
    # buffer_size is the size of waiting list
    {:producer, initial_state, buffer_size: 1}
  end

  # handle_demand(number_of_demands, producer_state)
  def handle_demand(demand, state) do
    Logger.info("Received demand for #{demand} pages")
    events = []
    {:noreply, events, state}
  end

  def scrape_pages(pages) do
    GenStage.cast(__MODULE__, {:pages, pages})
  end

  def handle_cast({:pages, pages}, state) do
    {:noreply, pages, state}
  end
end
