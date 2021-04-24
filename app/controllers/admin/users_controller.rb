class Admin::UsersController < ApplicationController
  before_action :login_check
  before_action :admin_user

  def top
  end

  def index
    @users = User.where(shop_id: current_user.shop_id)
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user.password = "1111"
    if user.save!
      redirect_to admin_users_path
    else
      redirect_to root_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:shop_id,:user_id,:name,:age,:work_status,:license,:rookie)
    end
end
