defmodule TwitterGrapher.TwitterController do
  use TwitterGrapher.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"screen_name" => screen_name}) do
    user = Twitter.UserRetriever.user(screen_name)
    followers = Twitter.FollowerRetriever.followers(screen_name)

    # Previously a single query was being built and executed only once to add
    # all the nodes, the update_relationship approach executes multiple queries
    # but will ensure no duplicate nodes/relations are created, this can be
    # reduced into a single query once I get more familiar with neo4j.
    Neo4j.Utils.update_relationship(twitter_user: user, followers: followers)

    text conn, "Successfully stored Twitter user and followers"
  end
end
