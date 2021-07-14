class UsersController < ApplicationController
  before_action :login_check, only: [:index, :edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:destroy]

  def top
  end

  def index
    @users = User.where(shop_id: @current_user.shop_id)
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user.password = "password"
    if user.save!
      log_in user
      redirect_to top_users_path + "#/staff/requested_shifts/"
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

    private
    #ログイン処理(ブラウザのcookieにユーザー情報を保存)
    def log_in(user)
      session[:user_id] = user.id
    end
    
    #ログアウト処理(ブラウザのcookieに保存しているユーザー情報を破棄)
    def log_out
      session.delete(:user_id)
      @current_user = nil
    end
end
