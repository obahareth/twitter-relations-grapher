defmodule TwitterGrapher.TwitterController do
  use TwitterGrapher.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"screen_name" => screen_name}) do
    user = Twitter.UserRetriever.user(screen_name)
    followers = Twitter.FollowerRetriever.followers(screen_name)

    query = Neo4j.QueryBuilder.create_twitter_user_and_followers(user,
                                                                 followers)

    IO.puts query

    db_conn = Bolt.Sips.conn
    Bolt.Sips.query!(db_conn, query)

    text conn, "Successfully stored Twitter user and followers"
  end
end
