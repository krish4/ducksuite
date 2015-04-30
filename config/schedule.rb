# Fetch new pictures from Instagram every hour
every 10.minutes do
  rake "instagram:fetch_new_pictures"
end