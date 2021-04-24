class Admin::RequestedShiftsController < ApplicationController
  before_action :login_check
  before_action :admin_user
end
