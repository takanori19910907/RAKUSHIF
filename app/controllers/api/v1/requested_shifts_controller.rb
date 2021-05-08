class Api::V1::RequestedShiftsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    user = current_user
    render json: user
  end

  def show
    shifts = current_user.requested_shifts
    render json: shifts
  end

  def create
    # stateに蓄積されたデータ(shifts)を受け取りオブジェクトを作成してDBへ保存
    params.require(:shifts).each do |record|
      clockIn = record[:year].to_s + "-" + record[:month].to_s + "-" + record[:day].to_s + "-" +  record[:clockIn] + ":00"
      clockOut = record[:year].to_s + "-" + record[:month].to_s + "-" + record[:day].to_s + "-" +  record[:clockOut] + ":00"
      binding.pry
      shift = current_user.requested_shifts.build(
        shop_id: current_user.shop_id,
        clock_in: clockIn,
        clock_out: clockOut,
      )
      shift.save
    end
    redirect_to root_path
  end
end
