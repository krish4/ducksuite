class ApplicationController < ActionController::Base
  before_filter :set_gon

  protected
  def redis_client
    RedisClient.new
  end

  def is_admin?
    user_signed_in? && current_user.is_admin?
  end

  def set_gon
    gon.client_id = ENV['INSTAGRAM_CLIENT_ID']
  end
end
