REDIS = if ENV["REDISCLOUD_URL"]
  Redis.new(:url => ENV["REDISCLOUD_URL"])
else
  Redis.new
end
