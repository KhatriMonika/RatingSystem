class Api::V1::BaseController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :bad_record
   skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
   before_filter :authenticate
  protected

  def render_json(json) 
    callback = params[:callback]
    response = begin
      if callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => :js, :text => response})
  end

  def bad_record
    render_json({:errors => "No Record Found!", :status => 404}.to_json)
  end

  def parameter_errors
    render_json({:errors => "You have supplied invalid parameter list.", :status => 404}.to_json)
  end

  def authenticate
      @auth_token = AccessKey.find_by_access_token(params[:auth_token])
      if !(@auth_token.present?)
        render_json({:errors => "Unauthorized", :status => 404}.to_json)
      end
  end

  def admin
    @admin = Employee.find(@auth_token.employee_id)
    if !(@admin.admin?)
      render_json({:errors => "Access to that area requires additional privileges.", :status => 404}.to_json)
    end
  end


  def project_manager
    @project_manager = Employee.find(@auth_token.employee_id)
    if !(@project_manager.project_manager?)
      render_json({:errors => "Access to that area requires additional privileges.", :status => 404}.to_json)
    end
  end

  def fetch_Employee
    @employee = Employee.find(AccessKey.find_by_access_token(params[:auth_token]).employee_id)
  end

  def not_employee
    @employee = Employee.find(@auth_token.employee_id)
    if (@employee.employee?)
      render_json({:errors => "Access to that area requires additional privileges.", :status => 404}.to_json)
    end
  end

end
