defmodule PageConsumerSupervisor do
  use ConsumerSupervisor
  require Logger

  def start_link(_args) do
    ConsumerSupervisor.start_link(
      __MODULE__,
      :ok,
      # We should put name so that OnlinePageProducerConsumer can find it.
      name: __MODULE__
    )
  end

  # State is irrelevant, so we just put :ok
  def init(:ok) do
    Logger.info("PageConsumerSupervisor init")

    children = [
      %{
        id: PageConsumer,
        start: {PageConsumer, :start_link, []},
        restart: :transient
      }
    ]

    opts = [
      strategy: :one_for_one,
      # No need to subscribe - OnlinePageProducerConsumer will just find us.
      subscribe_to: []
    ]

    ConsumerSupervisor.init(children, opts)
  end
end
