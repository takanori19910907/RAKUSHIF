class Api::V1::RequestedShiftsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    shifts = RequestedShift.all
    render json: shifts
  end

  def show
    shifts = RequestedShift.find(params[:id])
    render json: shifts
  end

  private
end
