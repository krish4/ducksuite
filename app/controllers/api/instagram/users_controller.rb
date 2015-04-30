class API::Instagram::UsersController < API::BaseController

  # Returns basic information about a user.
  # id - Instagram's user.id
  def show
    client = User.get_instagram_client(current_user)
    user = client.user(params[:id])
    render json: user
  end

end
