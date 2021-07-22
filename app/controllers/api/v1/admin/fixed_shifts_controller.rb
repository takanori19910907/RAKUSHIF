class Api::V1::Admin::FixedShiftsController < ApplicationController
  before_action :get_month, only: [:index]

  def index
    # 所属店舗のシフトデータを検索し、現在から１ヶ月先の期間で絞り込んで取得
    @shifts = FixedShift.where(shop_id: current_user.shop_id, clock_in: @month.all_month)
  end

  def create
    params.require(:shifts).each do |record|
      user = User.find_by(id: record[:user_id])
      shift = FixedShift.new(
        shop_id: user.shop_id,
        user_id: user.id,
        clock_in: record[:clock_in], 
        clock_out: record[:clock_out]
      )
      shift.save!
    end
  end

  def update
    targetShift = FixedShift.find_by(id: params[:id], user_id: params[:shiftData][:user_id])
    targetShift.update(
      clock_in: "#{params[:shiftData][:year]}-#{params[:shiftData][:month]}-#{params[:shiftData][:date]} #{params[:shiftData][:clockIn]}:00",
      clock_out: "#{params[:shiftData][:year]}-#{params[:shiftData][:month]}-#{params[:shiftData][:date]} #{params[:shiftData][:clockOut]}:00",
    )
    head :no_content
  end

  def destroy
    targetShift = FixedShift.find(params[:id])
    targetShift.destroy
    head :no_content
  end

  private
    def get_month
      #取得するシフトの絞り込みのため、デフォルトの設定期間として日付範囲を定義(現在の日にちを基準に前後１ヶ月)
      @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    end
end
