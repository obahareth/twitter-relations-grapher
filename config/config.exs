# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :twitter_grapher,
  ecto_repos: [TwitterGrapher.Repo]

# Configures the endpoint
config :twitter_grapher, TwitterGrapher.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Zp5oLA9okrJkjnBRmi2jwKRNBkP4tsPrTrzodJC3/T4PJ1+sSFqhN4O6EaXNX4As",
  render_errors: [view: TwitterGrapher.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TwitterGrapher.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :extwitter, :oauth, [
   consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
   consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
   access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
   access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")
]
