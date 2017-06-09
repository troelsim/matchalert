defmodule Matches.Status do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: Matches.Status)
  end

  def init(:ok) do
    poll()
    {:ok, []}
  end

  def poll do
    Process.send_after(self(), {:"$gen_cast", :poll}, 30000)
  end

  @doc """
  Retuns true if "status" is "In progress"

  ## Examples

    iex> Matches.Status.is_running(%{"status" => "In progress"})
    true
    iex> Matches.Status.is_running(%{"status" => "In pingpong"})
    false
    iex> Matches.Status.is_running(%{})
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

    iex> Matches.Status.started_matches([
    ...>   %{"id" => "123", "status" => "In progress"},
    ...>   %{"id" => "234", "status" => "In progress"}
    ...> ], [
    ...>   %{"id" => "123", "status" => "Something"},
    ...>   %{"id" => "234", "status" => "In progress"}
    ...> ])
    [%{"id" => "123", "status" => "In progress"}]

    iex> Matches.Status.started_matches([
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

    iex> Matches.Status.finished_matches([
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

  @doc """
  Returns status or nil, either for a map or for an element in an Enum, matched by id

  ## Examples

    iex> Matches.Status.get_status([%{"id" => 1, "status" => "something"}], 1)
    "something"

    iex> Matches.Status.get_status(nil)
    nil

    iex> Matches.Status.get_status(%{"status" => "hello"})
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
  Get matches with changed status from two lists


  ## Examples

    iex> Matches.Status.event_changes([
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
      merge_events(new_events, events)
      #|> Enum.filter(fn event -> event["status"] != "Finished" end)
    }
  end

  def handle_call({:get_matches}, _from, events) do
    { :reply, events, events }
  end

  def handle_cast(:poll, events) do
    new_events = Matches.Getter.get_live_events()
    {:reply, return_value, new_state} = handle_call({:get_changes, new_events}, self(), events)
    Matches.Change.handle_match_changes(return_value)
    if return_value != [] do
#      IO.inspect(return_value)
    end
    poll()
    {:noreply, new_state}
  end
end
