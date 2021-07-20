class Api::V1::Staff::FixedShiftsController < ApplicationController
  before_action :get_month

  def index
    # 所属店舗のシフトデータを検索し、現在から１ヶ月先の期間で絞り込んで取得
    @shifts = FixedShift.where(shop_id: current_user.shop_id, clock_in: @month.all_month)
  end

  def current_user_fixed_shifts
    @shifts = current_user.fixed_shifts.where(clock_in: @from...@to)
    render :shifts
  end

  private
    def get_month
      #取得するシフトの絞り込みのため、デフォルトの設定期間として日付範囲を定義(現在の日にちを基準に前後１ヶ月)
      @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    end
end
