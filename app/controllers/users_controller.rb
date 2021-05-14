class UsersController < ApplicationController
  before_action :login_check
  before_action :admin_user, except: [:top]
  before_action :set_user, only: [:edit, :update, :destroy]

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
    user.password = "password"
    if user.save!
      redirect_to users_path
    else
      redirect_to root_path
    end
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
        flash[:success] = "グループ情報を変更しました"
    else
        flash[:danger] = "グループ情報変更に失敗しました。再度やり直してください"
    end
    redirect_to users_path
  end

  def destroy
    @user.destroy
      flash[:success] = "#{@user.name}さんのアカウントを削除しました"
    redirect_to users_path
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:shop_id,:user_id,:name,:age,:work_status,:license,:rookie)
    end
end
