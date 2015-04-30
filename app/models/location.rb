class Location < ActiveRecord::Base
  belongs_to :album
  validates_presence_of :name, :latitude, :longitude, :radius, :album

  def area_contains?(lat, long)
    distance_between(point, [lat, long]) <= radius
  end

  def point
    [latitude, longitude]
  end

  private
    # Distance between two points on Earth (Haversine formula) in meters.
    def distance_between(point1, point2)
      earth_radius_in_meters = 6371000
      radian_per_degree = Math::PI/180

      # Delta latitudes and longitudes in radians.
      delta_lat = (point2[0] - point1[0]) * radian_per_degree
      delta_lng = (point2[1] - point1[1]) * radian_per_degree

      lat1 = point1.first * radian_per_degree
      lat2 = point2.first * radian_per_degree

      a = Math.sin(delta_lat / 2) ** 2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(delta_lng / 2) ** 2
      b = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

      earth_radius_in_meters * b
    end
end
