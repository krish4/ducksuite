class HomeController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout "angular"

  def index
  end

end
