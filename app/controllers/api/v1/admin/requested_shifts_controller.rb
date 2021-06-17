class Api::V1::Admin::RequestedShiftsController < Api::V1::BaseController
  def index
    shifts = RequestedShift.all
    render json: shifts
    # users = User.all
    # render json: { shifts: shifts, users: users }
  end
end
