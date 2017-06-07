defmodule Headsup.Email do
  use Bamboo.Phoenix, view: Headsup.EmailView

  def confirmation_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("troels@zafeguard.com")
    |> subject("Required: Confirm your email address")
    |> text_body("Go to asdfadsfadsf.com to activate your email address")
  end
end
