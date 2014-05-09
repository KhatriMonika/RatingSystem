class Api::V1::LeavesController < Api::V1::BaseController
  include LeaveModule
  before_action :set_leave, only: :update
  def create
    @leave = Leave.new(leave_params)
    @leave.employee_id = fetch_Employee.id
    @leave.date_of_application = Date.today
    if @leave.save
      if @leave.not_reviewed?
        #send_notification_of_application(@leave)
      end
      render_json({:success => "Successfully Applied for Leave"}.to_json)
    else
      parameter_errors
    end
  end

  def reason_categories
    @reason_categories = LeaveReasonCategory.all
  end

  def index
    @user = fetch_Employee
    if @user.admin?
      @team_members_leaves = Leave.upcoming_leaves.leave_status_not("Cancled").leave_status_not("Draft").includes(:leave_reason_category,:employee)
    else
      if @user.project_manager? && @user.team.present? && @user.team.team_members.present?
        employee_ids = @user.team.team_members.pluck("id")
        @team_members_leaves = Leave.upcoming_leaves.selected_employee_leaves(employee_ids).leave_status_not("Cancled").leave_status_not("Draft").includes(:leave_reason_category,:employee)
      end
      @leaves = Leave.upcoming_leaves.leave_status_not("Cancled").selected_employee_leaves(@user.id).includes(:leave_reason_category,:employee)
    end
  end

  def update
    if params[:status].present?
      @leave.update_attributes(status: Leave::STATUS.index(params[:status]), date_of_approval: Date.today)
      render_json({:success => "Leave successfully #{params[:status]}."}.to_json)
    else
      if @leave.update(leave_params)
        if fetch_Employee.id != @leave.employee_id
          @leave.update_attributes(date_of_approval: Date.today)
        end
        render_json({:success => "Leave successfully updated."}.to_json)
      else
        render_json({:error => "#{@leave.errors.full_messages.join(',')}"}.to_json)
      end
    end
  end

  private

  def set_leave
    @leave = Leave.find(params[:id])
  end

  def leave_params
    params.require(:leave).permit(:leave_required_from, :leave_required_to, :leave_options, :informed_to_client, :reason_of_leave, :note, :status, :leave_reason_category_id)
  end
end
