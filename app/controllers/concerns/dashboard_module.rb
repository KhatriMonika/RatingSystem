module DashboardModule
  def upcoming_leaves
    if current_user.admin?
      @leaves_d = Leave.upcoming_leaves.leave_status("Sanctioned")
    elsif current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
      employee_ids = current_user.team.team_members.pluck("id")
      @leaves_d = Leave.where(employee_id: employee_ids).upcoming_leaves.leave_status("Sanctioned").leave_status_not("Draft")
    else
      @leaves_d = Leave.upcoming_leaves.leave_status("Sanctioned").where("employee_id = ?",current_user.id)
    end
  end 

  def dashboard_calendar_events
    @events = []    
    data = JSON.parse(Net::HTTP.get(URI.parse("https://www.googleapis.com/calendar/v3/calendars/#{current_user.email}/events?access_token=#{current_user.auth_token}")))  
    if data["items"].present?
      data["items"].each do |item|
        @events << {:id => item["id"], :title => item["summary"], :description => "Test", :start => "#{item["start"]["dateTime"].present? ? (item["start"]["dateTime"]).to_date.to_s : (item["start"]["date"]).to_date.to_s}", :end => "#{item["end"]["dateTime"].present? ? (item["end"]["dateTime"]).to_date.to_s : (item["end"]["date"]).to_date.to_s}", :backgroundColor => 'green', :borderColor => 'green'} 
      end
    end
    if current_user.admin?
      @leaves = Leave.where(status: Leave::STATUS.index("Sanctioned"))
    elsif current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
      employee_ids = current_user.team.team_members.pluck("id")
      employee_ids << current_user.id
      @leaves = Leave.where(status: Leave::STATUS.index("Sanctioned"),employee_id: employee_ids)
    else
      @leaves = Leave.where(status: Leave::STATUS.index("Sanctioned"),employee_id: current_user.id)
    end
    if @leaves.present?
      @leaves.each do |leave|
        @events << {:id => leave.id, :title => leave.employee.name == current_user.name ? "me" : leave.employee.name, :description => leave.reason_of_leave, :start => "#{leave.leave_required_from.iso8601}", :end => "#{leave.leave_required_to.iso8601}",:backgroundColor => leave.reason_category.colour , :borderColor => leave.reason_category.colour }
      end
    end
    @birthdays = Employee.upcomming_birthdays(Date.today, Date.today + 7)
    if @birthdays.present?
      @birthdays.each  do |bday|
        @events << {:id => bday.id, :title => bday.name + " Birthday", :description => "Birthday", :start => "#{Date.today.year}-#{bday.birthdate.month}-#{bday.birthdate.day}".to_date.iso8601, :end => "#{Date.today.year}-#{bday.birthdate.month}-#{bday.birthdate.day}".to_date.iso8601,:backgroundColor => 'pink', :borderColor => 'pink'}
      end
    end
  end
end