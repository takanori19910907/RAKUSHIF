class Api::V1::UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    users = User.all
    render json: users
  end

  def show
    users = User.find(params[:id])
    render json: users
  end
end
