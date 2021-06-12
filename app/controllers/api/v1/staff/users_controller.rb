class Api::V1::Staff::UsersController < ApplicationController
  def index
    render json: current_user
  end
end
