module SessionsHelper

  #ログイン処理(ブラウザのcookieにユーザー情報を保存)
  def log_in(user)
    session[:user_id] = user.id
  end
  #ログアウト処理(ブラウザのcookieに保存しているユーザー情報を破棄)
    def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  #ログイン中かどうか確認し、そうでない場合はログイン処理を行う
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  #ログイン判定(viewの表示切替用)
  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end
  
end
