class Api::V1::Staff::RequestedShiftsController < Api::V1::BaseController

  def index
    shifts = current_user.requested_shifts
    render json: shifts
  end

  def create
    # stateに蓄積されたデータ(shifts)を受け取りオブジェクトを作成してDBへ保存
    params.require(:shifts).each do |record|
      shift = @current_user.requested_shifts.build(
        shop_id: current_user.shop_id,
        clock_in: "#{record[:year]}-#{record[:month]}-#{record[:date]} #{record[:clockIn]}:00",
        clock_out: "#{record[:year]}-#{record[:month]}-#{record[:date]} #{record[:clockOut]}:00",
      )
      shift.save
    end
    redirect_to root_path
  end

  def update
    shift = current_user.requested_shifts.find(params[:id])
    shift.update(
      clock_in: "#{params[:shiftData][:year]}-#{params[:shiftData][:month]}-#{params[:shiftData][:date]} #{params[:shiftData][:clockIn]}:00",
      clock_out: "#{params[:shiftData][:year]}-#{params[:shiftData][:month]}-#{params[:shiftData][:date]} #{params[:shiftData][:clockOut]}:00",
    )
    head :no_content
  end

  def destroy
    shift = @current_user.requested_shifts.find(params[:id])
    shift.destroy
    head :no_content
  end
end
