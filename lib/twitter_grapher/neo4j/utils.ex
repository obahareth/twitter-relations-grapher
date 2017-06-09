defmodule Neo4j.Utils do
  def exists(key: key, value: value) do
    conn = Bolt.Sips.conn
    query = "MATCH (n { #{key}: '#{value}' }) RETURN n"
    result = Bolt.Sips.query!(conn, query)
    length(result) != 0
  end
end
