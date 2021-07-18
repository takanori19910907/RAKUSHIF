class Api::V1::Staff::FixedShiftsController < ApplicationController
  before_action :get_date_for_twomonths

  def index
    # 所属店舗のシフトデータを検索し、現在から１ヶ月先の期間で絞り込んで取得
    @shifts = FixedShift.where(shop_id: current_user.shop_id, clock_in: @from...@to)
  end

  def current_user_fixed_shifts
    binding.pry
    @shifts = current_user.fixed_shifts.where(clock_in: @from...@to)
    render :shifts
  end

  private
    def get_date_for_twomonths
      #取得するシフトの絞り込みのため、デフォルトの設定期間として２ヶ月間を定義
      today = Time.current.at_beginning_of_day
      @from = (today - 1 .month)
      @to = (@from + 1.month)
    end
end
