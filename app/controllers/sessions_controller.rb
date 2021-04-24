class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(user_id: params[:session][:user_id].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      if user.admin
        redirect_to top_admin_users_path
      else
        redirect_to top_staff_users_path
      end
    else
      flash[:danger] = "ユーザー情報と一致しません 再度入力してください"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
