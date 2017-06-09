# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :headsup,
  ecto_repos: [Headsup.Repo]

# Configures the endpoint
config :headsup, Headsup.Web.Endpoint,
  url: [host: "192.168.1.36"],
  secret_key_base: "bj6fcjl2jTtTGjdiT2RmUiRzVoLYnJeqb82YciKAr0+e9/M4ctVc2NoR+5a3v7nt",
  render_errors: [view: Headsup.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Headsup.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# SMTP
config :headsup, Notifications.Mailer,
  adapter: Bamboo.SMTPAdapter,
  port: 587,
  server: "smtp.sendgrid.net",
  username: "***REMOVED***",
  password: "***REMOVED***",
  tls: :if_available,
  ssl: false,
  retries: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
