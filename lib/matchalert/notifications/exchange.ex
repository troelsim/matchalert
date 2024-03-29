defmodule Notifications.Exchange do

  def send_start_emails(match) do
    start_emails(match) |> Enum.map(&Notifications.Mailer.deliver_later/1)
  end

  def send_finished_emails(match) do
    finished_emails(match) |> Enum.map(&Notifications.Mailer.deliver_later/1)
  end

  def start_emails(match) do
    Matchalert.Users.list_subscriptions_for_match(match)
    |> Enum.map(&Notifications.Email.match_start_email(match, &1))
  end

  def finished_emails(match) do
    Matchalert.Users.list_subscriptions_for_match(match)
    |> Enum.map(&Notifications.Email.match_finished_email(match, &1))
  end
end
