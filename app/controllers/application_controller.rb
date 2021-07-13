class ApplicationController < ActionController::Base
  before_action :current_user
  def login_check
    if current_user.nil?
      redirect_to root_url, danger: "ログインしてください"
    end
  end

  def admin_user
      redirect_to(root_path) unless current_user.admin
  end

  private
    #ログイン中かどうか確認し、そうでない場合はログイン処理を行う
    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end
end
