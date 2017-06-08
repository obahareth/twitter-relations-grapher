defmodule TwitterGrapher.TwitterController do
  use TwitterGrapher.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"screen_name" => screen_name}) do
    user = Twitter.UserRetriever.user(screen_name)
    followers = Twitter.FollowerRetriever.followers(screen_name)

    root_query = [
      "create (root:Person {name:'",
      user.name,
      "', twitter_id:'",
      user.id_str,
      "', screen_name:'",
      user.screen_name,
      "', profile_image_url:'",
      user.profile_image_url_https,
      "'}), "
    ]

    followers_query = Enum.with_index(followers) |>
    Enum.map(fn (follower_with_index) ->
      {follower, index} = follower_with_index

      [
        "(n_",
         Integer.to_string(index),
         ":Person {name:'",
         follower.name,
         "', twitter_id:'",
         follower.id_str,
         "', screen_name:'",
         follower.screen_name,
         "', profile_image_url:'",
         follower.profile_image_url_https,
         "'}), (root)-[:FOLLOWED_BY]->(n_",
         Integer.to_string(index),
         "), "
      ]
    end)

    # Convert to a string because Bolt doesn't support IO List
    # queries, and remove last comma followed by a whitespace
    query = to_string(root_query ++ followers_query) |>
            String.trim_trailing(", ")
    IO.puts query

    db_conn = Bolt.Sips.conn
    Bolt.Sips.query!(db_conn, query)

    text conn, "stored twitter relations for: #{screen_name}: #{inspect followers}"
  end
end
