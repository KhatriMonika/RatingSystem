class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, :with => :render_404
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include SessionsHelper
  require 'nexmo'
  before_action :token_validity,:user_signed_in,:define_new_leave_count
  protect_from_forgery with: :exception
  
  # Flash Type for a single error message
  add_flash_types :error

  def check_team_present
    if Team.all.count == 0
      gflash :error => "There is no data yet"
      redirect_to employee_path(current_user.slug)
    end
  end

  def check_role_not_employee
    if current_user.employee?
      gflash :error => "You are Not Authorized for that action" 
      redirect_to employee_path(current_user.slug)
    end
  end

  def check_role_admin
    if !current_user.admin?
      gflash :error => "You are Not Authorized for that action" 
      redirect_to employee_path(current_user.slug)
    end
  end

  def send_message(number,message)
    nexmo = Nexmo::Client.new('2b2ab676', '06fa97dd')
    nexmo.send_message!({:to => number, :from => 'AccuRate', :text => message})
  end 

  def routing
    render_404
  end

  def define_new_leave_count
    @count = 0
    if current_user.admin?
      @count = Leave.new_leaves_count
    elsif current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
      temp = Leave.selected_employee_leaves(current_user.team.team_members.pluck('id'))
      if temp.present?
        @count = temp.new_leaves_count
      end
    end
  end

  def update_google_token
    if current_user.token_expires_at.to_i - Time.now.to_i <= 0
      current_user.renew_google_auth_token
    end    
  end

  private
  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
    end
    render :file => "/public/404.html", :status => 404, :layout => false
  end
  
end