defmodule Neo4j.Utils do

  def get(key: key, value: value) do
    conn = Bolt.Sips.conn
    query = "MATCH (n { #{key}: '#{value}' }) RETURN n"
    Bolt.Sips.query!(conn, query)
  end

  def create(twitter_user: twitter_user) do
    conn = Bolt.Sips.conn
    query = "create (n:Person
           {name:'#{twitter_user.name}',
           twitter_id:'#{twitter_user.id_str}',
           screen_name:'#{twitter_user.screen_name}',
           profile_image_url:'#{twitter_user.profile_image_url_https}'})"

    Bolt.Sips.query!(conn, query)
  end

  def exists?(key: key, value: value) do
    conn = Bolt.Sips.conn
    query = "MATCH (n { #{key}: '#{value}' }) RETURN n"
    result = Bolt.Sips.query!(conn, query)
    length(result) != 0
  end

  def exists?(twitter_user: twitter_user) do
    exists?(key: "twitter_id", value: twitter_user.id_str)
  end

  def update?(twitter_user: twitter_user) do
     if exists?(key: "twitter_id", value: twitter_user.id_str) do
       conn = Bolt.Sips.conn
       query = "MATCH (n { twitter_id: '#{twitter_user.id_str}' })
                SET n.screen_name = '#{twitter_user.screen_name}'
                SET n.name = '#{twitter_user.name}'
                SET n.profile_image_url = '#{twitter_user.profile_image_url_https}'
                RETURN n"

      result = Bolt.Sips.query!(conn, query)
      length(result) != 0
     else
       false
     end
  end

  def update_relationship(twitter_user: twitter_user, follower: follower) do
    unless update?(twitter_user: twitter_user) do
      create(twitter_user: twitter_user)
    end

    unless update?(twitter_user: follower) do
      create(twitter_user: follower)
    end

    conn = Bolt.Sips.conn
    query = "MATCH (user { twitter_id: '#{twitter_user.id_str}' })
             MATCH (follower { twitter_id: '#{follower.id_str}' })
             MERGE (user)-[:FOLLOWED_BY]->(follower)
             return user, follower"

    Bolt.Sips.query!(conn, query)
  end

  def update_relationship(twitter_user: twitter_user, followers: followers) do
    for follower <- followers do
      update_relationship(twitter_user: twitter_user, follower: follower)
    end
  end
end
