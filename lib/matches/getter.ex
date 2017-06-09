defmodule Matches.Getter do
  @moduledoc """
  Documentation for Matches.
  """

  def zero_pad(n) do
    n |> Integer.to_string |> String.rjust(2, ?0)
  end

  def date_string(dt) do
    [dt.year, dt.month, dt.day]
    |> Enum.map(&zero_pad/1)
    |> Enum.join("-")
  end

  def time_string(dt) do
    [dt.hour, dt.minute, dt.second]
    |> Enum.map(&zero_pad/1)
    |> Enum.join("")
  end

  def score_url() do score_url(DateTime.utc_now) end
  def score_url(dt) do
    "http://ace.Matches.com/pulse/#{date_string(dt)}_livescores_new.json?v=#{time_string(dt)}"
  end

  def get_live_scores(http_library \\ HTTPoison) do
    {:ok, response} = http_library.get(score_url(), [], options: [recv_timeout: 10000])
    response.body |> Poison.decode!
  end

  def events(scores) do
    scores
    |> Map.get("tournaments")
    |> Enum.flat_map(fn tournament ->
      tournament["events"] |> Enum.map(&Map.put(&1, "tournament", tournament["name"]))
    end)
  end

  def get_live_events(http_library \\ HTTPoison) do
    get_live_scores(http_library) |> events
  end
end
