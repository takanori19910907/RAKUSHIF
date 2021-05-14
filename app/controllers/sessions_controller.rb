class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(user_id: params[:session][:user_id].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
        redirect_to top_users_path
    else
      flash[:danger] = "ユーザー情報と一致しません 再度入力してください"
      render 'new'
    end
  end

  def destroy
    log_out if @current_user
    redirect_to root_path
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
