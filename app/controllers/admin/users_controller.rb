class Admin::UsersController < ApplicationController
  before_action :login_check
  before_action :admin_user

  def top
  end
end
