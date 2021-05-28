class Api::V1::Admin::RequestedShiftsController < Api::V1::BaseController
  def index
    date = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
    shifts = RequestedShift.where(clock_in: date.beginning_of_day .. date.end_of_day)
    render json: shifts
  end
end
