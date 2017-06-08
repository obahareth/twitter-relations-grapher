defmodule Twitter.UserRetriever do
  def user(screen_name) do
    try do
      ExTwitter.user(screen_name)
    rescue
      e in ExTwitter.RateLimitExceededError ->
        :timer.sleep ((e.reset_in + 1) * 1000)
        user(screen_name)
    end
  end
end
