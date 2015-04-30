class API::UsersController < API::BaseController
  require 'net/http'
  protect_from_forgery with: :null_session
  skip_before_filter :check_access
  before_action :set_user, only: [:show, :edit, :update, :destroy, :authenticate, :info, :open, :close]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: show_params, status: :ok
  end

  def info
    render json: info_params, status: :ok
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    updated = if user_params.has_key?(:current_password) && user_params.has_key?(:password)
      @user.update_with_password(user_params)
    else 
      @user.update(user_params)
    end

    if updated
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def authenticate
    response = HTTParty.post('https://api.instagram.com/oauth/access_token', body: auth_params)
    if response.code == 200
      auth_data = JSON.parse(response.body)
      create_user_authentication(@user.id, auth_data["access_token"], auth_data["user"]["id"])
      render json: auth_data["user"], status: :ok
    else
      render json: response.body, status: response.code
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def open
    @user.update(closed_at: nil)
    head :no_content
  end

  def close
    @user.update(closed_at: Time.now)
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :brand, :password, :current_password, :closed_at)
  end

  def show_params
    {
      user: { 
        name:    @user.name, 
        email:   @user.email, 
        brand:   @user.brand, 
        domains: @user.domains 
      }, 
      authentications: build_authentications_params(@user.authentications)
    }
  end

  def info_params
    { 
      total_pictures:   @user.pictures_in_albums_number, 
      inbox_count:      @user.inbox_count, 
      is_authenticated: @user.is_authenticated("instagram") 
    }
  end

  def auth_params
    {
      client_id:     ENV["INSTAGRAM_CLIENT_ID"],
      client_secret: ENV["INSTAGRAM_CLIENT_SECRET"],
      redirect_uri:  "http://" + request.host_with_port,
      grant_type:    'authorization_code',
      code:          params[:code]
    }
  end

  def build_authentications_params(authentications)
    authentications.collect do |auth| 
      { 
        uid:      auth.uid, 
        provider: auth.provider 
      }
    end
  end

  def create_user_authentication(user_id, access_token, user_uid)
    auth = Authentication.where(user_id: user_id, provider: 'instagram').first_or_initialize
    auth.access_token = access_token
    auth.uid = user_uid
    auth.save
  end
end
