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
      redirect_to root_path
  end
end
