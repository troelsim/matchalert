defmodule Notifications.Email do
  import Bamboo.Email

  def subscription_uuid_url(subscription) do
    url = Application.get_env(:headsup, Headsup.Web.Endpoint)[:url]
    host = url[:host]
    [host: host, port: port, scheme: scheme] = Keyword.take(url, [:host, :port, :scheme])
    "#{scheme}://#{host}#{if port == 80 do "" else ":#{port}" end}/#{subscription.uuid}"
  end

  def confirmation_email(subscription) do
    new_email()
    |> to(subscription.email)
    |> from("Matchalert <admin@matchalert.net>")
    |> subject("Required: Confirm your email address")
    |> text_body("Go to #{subscription_uuid_url(subscription)} to activate your email address")
  end

  def reminder_email(subscription) do
    new_email()
    |> to(subscription.email)
    |> from("Matchalert <admin@matchalert.net>")
    |> subject("Here's your Matchalert subscription")
    |> text_body("Go to #{subscription_uuid_url(subscription)} to change settings or unsubscribe")
  end

  @doc """
    iex> Notifications.Email.players_string(%{"players" => [%{"name" => "Isner"}, %{"name" => "Mahut"}]})
    "Isner vs. Mahut"
  """
  def players_string(%{"players" => [player1, player2]}) do
    "#{player1["name"]} vs. #{player2["name"]}"
  end

  @doc """
    iex> Notifications.Email.match_start_email(
    ...>  %{"players" => [%{"name" => "Isner"}, %{"name" => "Mahut"}], "tournament" => "Wimbledon", "round" => "Quarterfinal"},
    ...>  %{email: "troels@matchalert.net"})
    %Bamboo.Email{
      from: "admin@matchalert.net",
      subject: "Isner vs. Mahut",
      text_body: "Isner vs. Mahut just started at the quarterfinal of the Wimbledon",
      to: "troels@matchalert.net"
    }
  """
  def match_start_email(match, subscription) do
    new_email()
    |> to(subscription.email)
    |> from("Matchalert <admin@matchalert.net>")
    |> subject(players_string(match))
    |> text_body("#{players_string(match)} just started at the #{match["round"] |> String.downcase} of the #{match["tournament"]}")
  end
end
