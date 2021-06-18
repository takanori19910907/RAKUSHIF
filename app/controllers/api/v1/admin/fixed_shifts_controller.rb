class Api::V1::Admin::FixedShiftsController < ApplicationController

  def index
    shifts = FixedShift.all
    render json: shifts
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
end
