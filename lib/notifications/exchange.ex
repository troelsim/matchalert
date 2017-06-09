defmodule Notifications.Exchange do

  def send_start_emails(match) do
    start_emails(match) |> Enum.map(&Notifications.Mailer.deliver_later/1)
  end

  def start_emails(match) do
    Headsup.Users.list_subscriptions_for_match(match)
    |> Enum.map(&Notifications.Email.match_start_email(match, &1))
  end
end
