class Api::V1::Staff::RequestedShiftsController < Api::V1::BaseController

  def index
    user = current_user
    render json: user
  end

  def show
    shifts = current_user.requested_shifts
    render json: shifts
  end

  def create
    # stateに蓄積されたデータ(shifts)を受け取りオブジェクトを作成してDBへ保存
    params.require(:shifts).each do |record|
      shift = @current_user.requested_shifts.build(
        shop_id: current_user.shop_id,
        clock_in: "#{record[:year]}-#{record[:month]}-#{record[:day]} #{record[:clockIn]}:00",
        clock_out: "#{record[:year]}-#{record[:month]}-#{record[:day]} #{record[:clockOut]}:00",
      )
      shift.save
    end
    redirect_to root_path
  end

  def update
    shift = current_user.requested_shifts.find_by(id: params[:shiftData][:id])
    shift.update(clock_in: params[:shiftData][:clockIn],clock_out: params[:shiftData][:clockOut])
    head :no_content
  end

  def destroy    
    shift = @current_user.requested_shifts.find_by(id: params[:requested_shift][:id])
    # binding.pry
    shift.destroy
    redirect_to top_users_path
    head :no_content
  end
end
