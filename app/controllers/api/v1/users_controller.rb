class Api::V1::UsersController < Api::V1::BaseController

  def index
    users = User.all
    render json: users
  end

  def show
    users = User.find(params[:id])
    render json: users
  end
end
