defmodule Headsup.Email do
  use Bamboo.Phoenix, view: Headsup.EmailView

  def confirmation_email(subscription) do
    new_email()
    |> to(Map.get(subscription, "email"))
    |> from("admin@matchalert.net")
    |> subject("Required: Confirm your email address")
    |> text_body("Go to http://matchalert.net/#{subscription.uuid} to activate your email address")
  end
end
