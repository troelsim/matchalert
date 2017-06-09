use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :headsup, Headsup.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :headsup, Headsup.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "***REMOVED***",
  password: "holahola",
  database: "headsup_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
