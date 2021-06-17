class Api::V1::Staff::FixedShiftsController < ApplicationController
  def index
    shifts = FixedShift.all
    render json: shifts
  end
end
