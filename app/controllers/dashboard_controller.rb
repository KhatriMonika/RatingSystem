class DashboardController < ApplicationController  
  before_action :update_google_token 
    include ChartModule,DashboardModule,RatingModule
    require 'client_builder'
    require 'google/api_client'
 
  def index
    notification_for_rating    
    @notification_employees = Employee.where(id: @to_be_notified_to_admin) if @to_be_notified_to_admin.present?
    upcoming_leaves 
    @birthdays = Employee.upcomming_birthdays(Date.today, Date.today + 7) 
    top_improving_degrading_data(nil,nil)
    @max_of_month_individual = FactorGuidline.maxofday * Date.today.end_of_month.day
    gauge_for_rating(current_user)
    regularity_of_employees(nil,nil)
  end 

  def dashboard_events
    google_events = []
    data = JSON.parse(Net::HTTP.get(URI.parse("https://www.googleapis.com/calendar/v3/calendars/#{current_user.email}/events?access_token=#{current_user.auth_token}")))  
    data["items"].each do |item|
      google_events << {:id => item["id"], :title => item["summary"], :description => "Test", :start => "#{item["start"]["dateTime"].present? ? (item["start"]["dateTime"]).to_date.to_s : (item["start"]["date"]).to_date.to_s}", :end => "#{item["end"]["dateTime"].present? ? (item["end"]["dateTime"]).to_date.to_s : (item["end"]["date"]).to_date.to_s}", :backgroundColor => 'purple', :borderColor => 'purple'} 
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
    upcomming_birthdays
    events = [] 
    @leaves.each do |leave|
      events << {:id => leave.id, :title => leave.employee.name == current_user.name ? "me" : leave.employee.name, :description => leave.reason_of_leave, :start => "#{leave.leave_required_from.iso8601}", :end => "#{leave.leave_required_to.iso8601}",:backgroundColor => leave.reason_category.colour , :borderColor => leave.reason_category.colour }
    end
    if @birthdays.present?
      @birthdays.each  do |bday|
        events << {:id => bday.id, :title => bday.name + " Birthday", :description => "Birthday", :start => "#{Date.today.year}-#{bday.birthdate.month}-#{bday.birthdate.day}".to_date.iso8601, :end => "#{Date.today.year}-#{bday.birthdate.month}-#{bday.birthdate.day}".to_date.iso8601,:backgroundColor => 'pink', :borderColor => 'pink'}
      end
    end
    render :text => (events + google_events).to_json
  end  
 

  private

  def params_check
    # date set
      if params[:startdate].present?  && params[:enddate].present? 
        @start_date = params[:startdate]
        @end_date   = params[:enddate]
    # if params not present than last 7 days data displayed
      else
        @start_date=(Date.today-7 ).to_s
        @end_date=(Date.today).to_s
      end
    
    # set default values for project manager
      if params[:project_manager_id].present?
        @project_manager = Employee.friendly.find(params[:project_manager_id])
      elsif current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
        @project_manager = current_user
      else
        @project_manager =  Employee.project_managers.joins([:team]).first
      end


    if current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
      @project_manager = current_user
    else
      @project_manager =  Employee.project_managers.joins([:team]).first
    end

    @factor_id = '0'     
    @ratings = datewise_employees_line_chart(@start_date,@end_date,@factor_id,@project_manager)

  end

  def max_rating_entry
    # this method return the maximum rating days entries from employee
    @max_rating_count = (Rating.rating_date(@start_date,@end_date).group(:employee_id).count).values.max 
    @max_rating_count.present? ? @max_rating_count : nil   
  end
end