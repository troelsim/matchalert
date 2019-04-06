defmodule Notifications.Email do
  use Bamboo.Phoenix, view: Matchalert.Web.EmailView

  def subscription_uuid_url(subscription) do
    url = Application.get_env(:matchalert, Matchalert.Web.Endpoint)[:url]
    host = url[:host]
    [host: host, port: port, scheme: scheme] = Keyword.take(url, [:host, :port, :scheme])
    "#{scheme}://#{host}#{if port == 80 do "" else ":#{port}" end}/#{subscription.uuid}"
  end

  def email() do
    new_email()
    |> from("Matchalert <admin@matchalert.net>")
    |> put_text_layout({Matchalert.Web.LayoutView, "email.text"})
    |> put_html_layout({Matchalert.Web.LayoutView, "email.html"})
  end

  def confirmation_email(subscription) do
    email()
    |> to(subscription.email)
    |> subject("Required: Confirm your email address")
    |> render("confirmation.text", subscription_link: subscription_uuid_url(subscription))
    |> render("confirmation.html", subscription_link: subscription_uuid_url(subscription))
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
    email()
    |> to(subscription.email)
    |> subject("#{players_string(match)} started")
    |> render("start.text", subscription_link: subscription_uuid_url(subscription), match: match)
    |> render("start.html", subscription_link: subscription_uuid_url(subscription), match: match)
  end

  @doc """
    iex> Notifications.Email.match_finished_email(
    ...>  %{"players" => [%{"name" => "Isner", "is_winner" => true}, %{"name" => "Mahut"}], "tournament" => "Wimbledon", "round" => "Quarterfinal"},
    ...>  %{email: "troels@matchalert.net"})
    %Bamboo.Email{
      from: "admin@matchalert.net",
      subject: "Isner vs. Mahut",
      to: "troels@matchalert.net"
    }
  """
  def match_finished_email(match, subscription) do
    winner = match["players"] |> Enum.find(&(&1["is_winner"]))
    email()
    |> to(subscription.email)
    |> subject("#{players_string(match)} finished")
    |> render("finish.text", subscription_link: subscription_uuid_url(subscription), match: match, winner: winner)
    |> render("finish.html", subscription_link: subscription_uuid_url(subscription), match: match, winner: winner)
  end
end
