# Taken from this snippet:
# https://github.com/parroty/extwitter/blob/6f4b2d2b7052f3b4d61c0c63baa17318f4c3db03/README.md#cursor

defmodule Twitter.FollowerRetriever do
  def follower_ids(screen_name, acc \\ [], cursor \\ -1) do
    cursor = fetch_next(screen_name, cursor)
    if Enum.count(cursor.items) == 0 do
      List.flatten(acc)
    else
      follower_ids(screen_name, [cursor.items|acc], cursor.next_cursor)
    end
  end

  defp fetch_next(screen_name, cursor) do
    try do
      ExTwitter.follower_ids(screen_name, cursor: cursor)
    rescue
      e in ExTwitter.RateLimitExceededError ->
        :timer.sleep ((e.reset_in + 1) * 1000)
        fetch_next(screen_name, cursor)
    end
  end
end
