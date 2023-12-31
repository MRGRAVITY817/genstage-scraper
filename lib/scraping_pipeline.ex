defmodule ScrapingPipeline do
  use Broadway
  require Logger

  def start_link(_args) do
    options = [
      name: ScrapingPipeline,
      producer: [
        module: {PageProducer, []},
        # Our PageProducer emits plain string like "twitter.com", 
        # but since Broadway requires messages to be in Broadway.Message
        # format, we use ScrapingPipeline.transform().
        transformer: {ScrapingPipeline, :transform, []}
      ],
      processors: [
        default: [max_demand: 1, concurrency: 2]
      ],
      batchers: [
        default: [batch_size: 1, concurrency: 2]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  def handle_message(_processor, message, _context) do
    if Scraper.online?(message.data) do
      Broadway.Message.put_batch_key(message, message.data)
    else
      Broadway.Message.failed(message, "offline")
    end
  end

  @doc """
  Transform plain string to Broadway message
  """
  def transform(event, _options) do
    %Broadway.Message{
      data: event,
      acknowledger: {ScrapingPipeline, :pages, []}
    }
  end

  @doc """
  Used by :acknowledger option in transform(). 
  It usually informs message broker that processing was successful or not.
  For our case, we don't wanna do anything - just return :ok.
  """
  def ack(:pages, _successful, _failed) do
    :ok
  end
end
