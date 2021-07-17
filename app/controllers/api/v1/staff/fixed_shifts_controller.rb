class Api::V1::Staff::FixedShiftsController < ApplicationController
  def index
    @shifts = FixedShift.all
  end

  def current_user_fixed_shifts
    shifts = current_user.fixed_shifts
    render :shifts
  end
end
