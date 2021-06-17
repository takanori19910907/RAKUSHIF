class Api::V1::Admin::RequestedShiftsController < Api::V1::BaseController
  def index
    shifts = RequestedShift.all
    users = User.all
    render json: { shifts: shifts, users: users }
  end
end
