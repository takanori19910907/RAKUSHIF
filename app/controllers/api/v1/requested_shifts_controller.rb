class Api::V1::RequestedShiftsController < Api::V1::BaseController
  before_action :set_shiftdata, only: [:destroy]

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

  def destroy
    @shift.destroy
    head :no_content
  end

  def update
  end

  private
    def set_shiftdata
      @shift = RequestedShift.find_by(id: params[:requested_shift][:id])
    end
end
