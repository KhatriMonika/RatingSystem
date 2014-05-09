class SystemMailer < ActionMailer::Base
  default from: "admin@complitech.net"
 
  def factors_change_email(user,factor)
    @user = user
    @factor = factor
    mail(to: @user.email, subject: 'New Factor is added')
  end

  def import_ratings_email(user, errors)
    @user = user
    @message = message
    puts errors
    @errors = errors
    mail(to: @user.email, subject: 'Status of Ratings Import Task')
  end

  def reminder_to_rate_team_members(project_manager,last_rating_date)
    @last_rating_date = last_rating_date
    @project_manager = project_manager
    mail(to: @project_manager.email, subject: 'Reminder For Rating')
  end

  def notification_of_rating_to_admin(rating_details)
    @details = rating_details
    mail(to: 'shreya@complitech.net', subject: 'Details of Project Managers who have Not provided Ratings')
  end

  def notification_of_leave_application(user,leave)
    @user = user
    @leave = leave
    mail(to: @user.email, subject: "#{@leave.employee.name} has applied for leave")
  end

  def notification_of_leave_status_change(user,leave)
    @user = user
    @leave = leave
    mail(to: @user.email, subject: "#{@leave.employee.name}'s leave is #{leave.status_name}")
  end
end