module LeaveModule
  def set_leaves_list
    if current_user.admin?
      @leaves = Leave.leave_date(Date.today-30,Date.today).leave_status_not("Cancled").leave_status_not("Draft").includes(:leave_reason_category,:employee)
    else
      if current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
        employee_ids = current_user.team.team_members.pluck("id")
        @team_members_leaves = Leave.selected_employee_leaves(employee_ids).leave_date(Date.today-30,Date.today).leave_status_not("Cancled").leave_status_not("Draft").includes(:leave_reason_category,:employee)
      end
      @leaves = Leave.leave_date(Date.today-30,Date.today).leave_status_not("Cancled").where("employee_id = ?",current_user.id).includes(:leave_reason_category,:employee)
    end
  end

  def set_leaves_for_calendar
    if current_user.admin?
      @leaves = Leave.where(status: Leave::STATUS.index("Sanctioned")).includes(:leave_reason_category,:employee)
    elsif current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
      employee_ids = current_user.team.team_members.pluck("id")
      employee_ids << current_user.id
      @leaves = Leave.where(status: Leave::STATUS.index("Sanctioned"),employee_id: employee_ids).includes(:leave_reason_category,:employee)
    else
      @leaves = Leave.where(status: Leave::STATUS.index("Sanctioned"),employee_id: current_user.id).includes(:leave_reason_category,:employee)
    end
  end

  def status_classes
    @status_classes = ["success", "danger", "warning", "info", "primary"]
  end

  def set_leave_options(leave)
    startDate = Date.parse(params[:leave][:leave_required_from])
    endDate = Date.parse(params[:leave][:leave_required_to])
    leave_options = ""
    while(endDate>=startDate) do
      if params[startDate.to_s].present? && !(startDate.sunday?)
        leave_options = leave_options  + params[startDate.to_s].to_s + ","
      end
      startDate = startDate + 1
    end
    leave.leave_options = leave_options
  end

  def set_informed_to_client(leave)
    if params[:leave][:informed_to_client] == "on"
      leave.informed_to_client = true
    else
      leave.informed_to_client = false
    end
  end

  def leave_sync_google(leave)
    if leave.sanctioned? 
      if leave.google_leave_id.present?
        google_calendar_event_update(LEAVE_CALENDAR_ID,@leave.google_leave_id,leave.employee.name,leave.leave_required_from.to_datetime,leave.leave_required_to.to_datetime)
        #send_notification_of_leave_status_change(leave)
      else
        leave.google_leave_id = google_calendar_event_insert(LEAVE_CALENDAR_ID,leave.employee.name,leave.leave_required_from.to_datetime,leave.leave_required_to.to_datetime)
        leave.save
        #send_notification_of_leave_status_change(leave)
      end
    elsif leave.not_sanctioned? && leave.google_leave_id.present?
      google_calendar_event_remove(LEAVE_CALENDAR_ID,@leave.google_leave_id)
      #send_notification_of_leave_status_change(leave)
    end
  end


  def send_notification_of_application(leave)
    employees = []
    employees << leave.employee.team.project_manager
    Employee.where(role_id: 0).each do |employee|
      employees << employee
    end
    employees.each do |employee|
      if (employee.devise_token.present?)
        employee.update_attributes(badge: employee.badge + 1)
        APNS.send_notification(employee.devise_token, :alert => "#{leave.employee.name} has applied for leave" , :badge => Employee.badge, :sound => 'default')
      end
      SystemMailer.notification_of_leave_application(employee,leave).deliver 
    end
  end

  def send_notification_of_leave_status_change(leave)
    employees = []
    Employee.where(role_id: 0).each do |employee|
      employees << employee
    end
    leave.employee.team.team_members.each do |employee|
      employees << employee
    end
    employees << leave.employee.team.project_manager
    employees.each do |employee|
      if (employee.devise_token.present?)
        employee.update_attributes(badge: employee.badge + 1)
        APNS.send_notification(employee.devise_token, :alert => "#{leave.employee.name} leave is #{leave.status_name}" , :badge => Employee.badge, :sound => 'default')
      end
      SystemMailer.notification_of_leave_status_change(employee,leave).deliver 
    end
  end
end