class Api::V1::SessionsController < Api::V1::BaseController
include Google,Api::V1::SessionsHelper
skip_before_filter :verify_authenticity_token   
skip_before_filter :authenticate, only: [:create]
  def create
    if params[:auth_token].present?      
      google_login(params[:auth_token])
	  else
		  render_json({:errors => "auth_token missing", :status => 404}.to_json)		
	  end
  end

  def logout
    fetch_Employee.update_attributes(devise_token: nil,badge: 0)
    @auth_token.destroy
    render_json({:message => "Successfully Logged Out", :status => 200}.to_json)
  end  

  def update_badge_to_zero
    @employee = fetch_Employee
    if @employee.present?
      @employee.update_attributes(badge: 0)
      render_json({:message => "Badge is Successfully Updated", :status => 200}.to_json)
    else
      bad_record
    end
  end
end