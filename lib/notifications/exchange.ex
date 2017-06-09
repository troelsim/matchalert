defmodule Notifications.Exchange do
  def send_start_emails(match) do
    subscriptions = match["players"]
    |> Enum.map( fn player ->
        Headsup.Users.list_subscriptions_for_player(player)
      end)
    |> MapSet.new
    |> Enum.reduce(&MapSet.union/2)
    subscriptions
    |> Enum.map fn subscription ->
      Notifications.Email.match_start_email(match, subscription)
      |> Notifications.Mailer.deliver_later()
    end
  end
end
