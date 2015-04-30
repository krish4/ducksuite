namespace :instagram do
  desc "Fetch and cache new pictures for albums"
  task fetch_new_pictures: :environment do
    redis = RedisClient.new
    Album.find_each do |album|
      puts "Fetching and caching new pictures for album ##{album.id}... \n"
      data = FetchNewPictures.new(nil, album).call
      CachePictures.new(data[:pictures], album.id, redis, true).call
      UpdateInboxNotifications.new(album.id, redis).call
    end
  end
end
