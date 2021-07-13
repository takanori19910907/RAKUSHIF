class GuestSessionsController < ApplicationController
  before_action :set_data, only: [:create]

  def create
    log_in @user
    if @user.admin
      redirect_to top_users_path + "#/admin/requested_shifts/"
    else
      redirect_to top_users_path + "#/staff/requested_shifts/"
    end
  end

  def destroy
    log_out if @current_user
    redirect_to root_path
  end

  private
  # ゲストログイン用の店/ユーザーデータをセット
    def set_data
      shop = Shop.find_or_create_by(
        id: 9999,
        name: "テストオンライン店舗"
      )

      @user = User.find_or_initialize_by(
        shop_id: shop.id,
        user_id: 9999,
        name:  "ゲスト",
        age: 30,
        work_status: 1,
        license: true,
        admin: true
      )

      @user.password = SecureRandom.urlsafe_base64
      @user.save!
    end
    
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
