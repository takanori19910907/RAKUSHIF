class ApplicationController < ActionController::Base
  include SessionsHelper
  def login_check
    if current_user.nil?
      redirect_to root_url, danger: "ログインしてください"
    end

  def admin_user
      redirect_to(root_path) unless current_user.admin
    end
  end
end
