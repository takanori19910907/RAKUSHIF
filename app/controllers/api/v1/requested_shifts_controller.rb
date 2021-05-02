class Api::V1::RequestedShiftsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    shifts = RequestedShift.all
    render json: shifts
    current_user = current_user
    render json: current_users
  end

  def show
    shifts = RequestedShift.find(params[:id])
    render json: shifts
  end

  def create
    @records = []
    params.require(:shifts).each do |record|
      clockIn = "2021-5-2-" + record[:clockIn] + ":00"
      clockOut = "2021-5-2-" + record[:clockOut] + ":00"
      shift = current_user.requested_shifts.build(
        shop_id: current_user.shop_id,
        clock_in: clockIn,
        clock_out: clockOut,
      )
      shift.save
    end
    redirect_to root_path
  end

  private
    def records_permit(params)
      params.permit(:clockIn, :clockOut)
    end
end
