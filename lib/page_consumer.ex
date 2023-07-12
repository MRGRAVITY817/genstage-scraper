defmodule PageConsumer do
  require Logger

  def start_link(event) do
    Logger.info("PageConsumer received #{event}")

    # run code in process and exit
    Task.start_link(fn ->
      Scraper.work()
    end)
  end
end
