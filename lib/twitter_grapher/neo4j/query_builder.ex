defmodule Neo4j.QueryBuilder do
  def create_twitter_user_and_followers(user, followers) do
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
    to_string(root_query ++ followers_query)
    |> String.trim_trailing(", ")
  end
end
