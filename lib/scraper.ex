defmodule Scraper do
  @moduledoc """
  Documentation for `Scraper`.
  """

  def work() do
    # will do some dummy work that takes time
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end
end
