defmodule Headsup.Email do
  use Bamboo.Phoenix, view: Headsup.EmailView

  def subscription_uuid_url(subscription) do
    url = Application.get_env(:headsup, Headsup.Web.Endpoint)[:url]
    host = url[:host]
    [host: host, port: port, scheme: scheme] = Keyword.take(url, [:host, :port, :scheme])
    "#{scheme}://#{host}#{if port == 80 do "" else ":#{port}" end}/#{subscription.uuid}"
  end

  def confirmation_email(subscription) do
    new_email()
    |> to(subscription.email)
    |> from("admin@matchalert.net")
    |> subject("Required: Confirm your email address")
    |> text_body("Go to #{subscription_uuid_url(subscription)} to activate your email address")
  end
end
