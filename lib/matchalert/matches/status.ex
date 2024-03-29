defmodule Matchalert.Matches.Status do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: Matchalert.Matches.Status)
  end

  def init(:ok) do
    poll()
    {:ok, recall() || []}
  end

  def poll do
    Process.send_after(self(), {:"$gen_cast", :poll}, 30000)
  end

  defp redis_url() do
    System.get_env("REDIS_URL")
  end

  @doc """
  Retuns true if "status" is "In progress"

  ## Examples

    iex> is_running(%{"status" => "In progress"})
    true
    iex> is_running(%{"status" => "In pingpong"})
    false
    iex> is_running(%{})
    false
  """
  def is_running(event) do
    event["status"] == "In progress"
  end

  def is_finished(event) do
    event["status"] == "Finished"
  end

  @doc """
  Returns the events from new_events that are "In progress" and are not so in events

  ## Examples

    iex> started_matches([
    ...>   %{"id" => "123", "status" => "In progress"},
    ...>   %{"id" => "234", "status" => "In progress"}
    ...> ], [
    ...>   %{"id" => "123", "status" => "Something"},
    ...>   %{"id" => "234", "status" => "In progress"}
    ...> ])
    [%{"id" => "123", "status" => "In progress"}]

    iex> started_matches([
    ...>   %{"id" => "123", "status" => "In progress"},
    ...> ], [])
    [%{"id" => "123", "status" => "In progress"}]
  """
  def started_matches(new_events, events) do
    running_events = events |> Enum.filter(&is_running/1)
    new_events
    |> Enum.filter(&is_running/1)
    |> Enum.filter(fn new_event ->
      !Enum.any?(Enum.map(running_events, fn event ->
        new_event["id"] == event["id"]
      end))
    end)
  end

  @doc """
  Returns the events from new_events that are "Finished " and are not so in events

  ## Examples

    iex> finished_matches([
    ...>   %{"id" => "123", "status" => "Finished"},
    ...>   %{"id" => "234", "status" => "In progress"}
    ...> ], [
    ...>   %{"id" => "123", "status" => "In progress"},
    ...>   %{"id" => "123", "status" => "In progress"}
    ...> ])
    [%{"id" => "123", "status" => "Finished"}]
  """
  def finished_matches(new_events, events) do
    running_events = events |> Enum.filter(&is_running/1)
    new_events
    |> Enum.filter(&is_finished/1)
    |> Enum.filter(fn new_event ->
      Enum.any?(Enum.map(running_events, fn event ->
        new_event["id"] == event["id"]
      end))
    end)
  end

  def persist(events) do
    try do
      {:ok, conn} = Redix.start_link(redis_url())
      Redix.command(conn, ["SET", "match_state", :erlang.term_to_binary(events)])
      Redix.stop(conn)
      events
    rescue
      _ -> events
    end
  end

  def recall() do
    try do
      {:ok, conn} = Redix.start_link(redis_url())
      {:ok, bin} = Redix.command(conn, ["GET", "match_state"])
      events = case bin do
        nil -> []
        something -> :erlang.binary_to_term(something)
      end
      Redix.stop(conn)
      events
    rescue
      _ -> []
    end
  end

  @doc """
  Returns status or nil, either for a map or for an element in an Enum, matched by id

  ## Examples

    iex> get_status([%{"id" => 1, "status" => "something"}], 1)
    "something"

    iex> get_status(nil)
    nil

    iex> get_status(%{"status" => "hello"})
    "hello"
  """
  def get_status(events, id) when is_list(events) do
    Enum.find(events, fn ev -> ev["id"] == id end) |> get_status
  end
  def get_status(nil) do nil end
  def get_status(event) do
    Map.get(event, "status")
  end

  def get_event(new_events, events, id) do
    Enum.find(new_events, fn ev -> ev["id"] == id end) || Enum.find(events, fn ev -> ev["id"] == id end)
  end

  @doc """
  Get Matchalert.Matches with changed status from two lists


  ## Examples

    iex> event_changes([
    ...>   %{"id" => 1, "status" => "something"},
    ...>   %{"id" => 2, "status" => "something else"}
    ...> ], [
    ...>   %{"id" => 1, "status" => "somethingz"},
    ...>   %{"id" => 2, "status" => "something else"}
    ...> ])
    [{"somethingz", "something", %{"id" => 1, "status" => "something"}}]
  """
  def event_changes(new_events, events) do
    current_ids = MapSet.new(events |> Enum.map(&Map.get(&1, "id")))
    new_ids = MapSet.new(new_events |> Enum.map(&Map.get(&1, "id")))
    MapSet.union(current_ids, new_ids)
    |> MapSet.to_list
    |> Enum.map(fn id ->
      {
        get_status(events, id),
        get_status(new_events, id),
        get_event(new_events, events, id)
      }
    end)
    |> Enum.filter(fn {old_status, new_status, _} -> old_status != new_status end)
  end

  def merge_events(new_events, events) do
    MapSet.union(
      MapSet.new(events |> Enum.map(&Map.get(&1, "id"))),
      MapSet.new(new_events |> Enum.map(&Map.get(&1, "id")))
    )
    |> MapSet.to_list
    |> Enum.map(&get_event(new_events, events, &1))
  end

  def handle_call({:get_changes, new_events}, _from, events) do
    {
      :reply,
      event_changes(new_events, events),
      merge_events(new_events, events) |> persist()
      #|> Enum.filter(fn event -> event["status"] != "Finished" end)
    }
  end

  def handle_call({:get_matches}, _from, events) do
    { :reply, events, events }
  end

  def handle_cast(:poll, events) do
    poll()
    case Matchalert.Matches.Getter.get_live_events() do
      {:ok, new_events} ->
        {:reply, return_value, new_state} = handle_call({:get_changes, new_events}, self(), events)
        Matchalert.Matches.Change.handle_match_changes(return_value)
        {:noreply, new_state}
      {:error, _} ->
        {:noreply, events}
    end
  end
end
