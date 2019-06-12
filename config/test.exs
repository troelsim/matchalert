use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :matchalert, Matchalert.Web.Endpoint,
  http: [port: 4001],
  url: [host: "localhost", port: 4001, scheme: "http"],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :matchalert, Matchalert.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "holahola",
  database: "matchalert_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
