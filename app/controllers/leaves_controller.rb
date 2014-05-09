class LeavesController < ApplicationController
  include Google,GoogleCalendarClientModule,LeaveModule
  before_action :set_leave, only: [:edit, :update, :destroy]
  before_action :set_leaves_list, :status_classes, only: [:index,:new,:create, :edit, :update]
  before_action :set_calendar_client, only: [:update,:destroy]
  before_action :update_google_token  
  def new
    @leave = Leave.new
    @startDate = params[:leave_required_from].present? ? params[:leave_required_from] : (Date.today + 1).to_s
    @endDate = params[:leave_required_to].present? ? params[:leave_required_to] : (Date.today + 1).to_s
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def index
  end

  def edit
    @startDate = params[:leave_required_from].present? ? params[:leave_required_from] : @leave.leave_required_from.to_s
    @endDate = params[:leave_required_to].present? ? params[:leave_required_to] : @leave.leave_required_to.to_s
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # for display sanctioned leaves in calendar
  def get_leaves
    set_leaves_for_calendar
    leaves = [] 
    if @leaves.present?
      @leaves.each do |leave|
        leaves << {:id => leave.id, :title => leave.employee.name == current_user.name ? "me" : leave.employee.name, :description => leave.reason_of_leave, :start => "#{leave.leave_required_from.iso8601}", :end => "#{leave.leave_required_to.iso8601}",:backgroundColor => leave.leave_reason_category.colour , :borderColor => leave.leave_reason_category.colour}
      end
    end
    render :text => leaves.to_json
  end

  def create
    @leave = Leave.new(leave_params)
    @leave.employee_id = current_user.id
    set_informed_to_client(@leave)
    set_leave_options(@leave)
    if @leave.save
      gflash :success => 'Leave is Successfully Created.'
      if @leave.not_reviewed?
        #send_notification_of_application(@leave)
      end
      redirect_to leaves_path
    else
      @startDate = params[:leave][:leave_required_from]
      @endDate = params[:leave][:leave_required_to]
      render action: 'new'
    end
  end

  def update
    if params[:status].present?
      @leave.update_attributes(status: Leave::STATUS.index(params[:status]), date_of_approval: Date.today)
      gflash :success => "Leave was successfully #{params[:status]}."
    else
      set_informed_to_client(@leave)
      set_leave_options(@leave)
      if @leave.update(leave_params)
        if @leave.not_reviewed? && current_user.id != @leave.employee_id
          @leave.update_attributes(status: Leave::STATUS.index("Reviewed"))
        end
        if @leave.not_reviewed?
          #send_notification_of_application(@leave)
        end
        if current_user.id != @leave.employee_id
          @leave.update_attributes(date_of_approval: Date.today)
        end
        gflash :success => "Leave was successfully updated."
      else
        @startDate = @leave.leave_required_from.to_s
        @endDate = @leave.leave_required_to.to_s
        render action: 'edit'
      end
    end
    leave_sync_google(@leave)
    redirect_to leaves_path
  end

  def destroy
    if @leave.sanctioned? && @leave.google_leave_id.present?
      google_calendar_event_remove(LEAVE_CALENDAR_ID,@leave.google_leave_id)
      #send_notification_of_leave_status_change(@leave)
    end
    @leave.update_attributes(status: Leave::STATUS.index("Cancled"))
    gflash :success => "Leave application is successfully Cancled."
    redirect_to leaves_path
  end

  private

  def set_leave
    @leave = Leave.find(params[:id])
  end

  def leave_params
    params.require(:leave).permit(:date_of_application, :date_of_approval, :reporting_to, :leave_required_from, :leave_required_to, :leave_options, :informed_to_client, :reason_of_leave, :note, :status, :leave_reason_category_id)
  end
end
