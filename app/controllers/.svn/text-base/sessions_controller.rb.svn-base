class SessionsController < ApplicationController
  include Google
  skip_before_action :user_signed_in,:define_new_leave_count, only: [:new, :create, :authentication_lock_screen, :omniauth_failure] 
  layout 'login'
  def new
    token = session[:token]
    if token.present? 
      @employee = Employee.find(AccessKey.find_by_access_token(token).employee_id)
      redirect_to employee_path(@employee.slug)
    else
     @employee = Employee.new
    end
  end 

  def create
    if env["omniauth.auth"].info.email.split('@').last == "complitech.net"
      employee = Employee.from_omniauth(env["omniauth.auth"])
      if employee.active == true        
        employee.save!
        token = employee.access_keys.create!
        session[:token] = token.access_token
        current_user = employee
        gflash :now,:success => "Successfully Signed in..!" 
        redirect_to dashboard_index_path
      else
        gflash :now,:error => "Sorry your account has been deactive" 
        render "new"
      end
    else
     gflash :now,:error => "Guest Users Not allowed" 
      render "new"
    end
  end

  def authentication_lock_screen
    if params[:employee][:password].present?
      google_login(params[:employee][:name],params[:employee][:password])
    else
      gflash :now,:error => "Password cant't be blank"
      redirect_to locked_employee_index_path
    end    
  end

  def omniauth_failure
    gflash :now,:error => "You need to accept the permissions to login"
    redirect_to root_url    
  end

  def logout
    token = cookies[:remember_token].present? ? cookies[:remember_token] : session[:token] 
    access_key = AccessKey.find_by_access_token(token)
    if access_key.present?
      AccessKey.find(access_key.id).destroy
      session[:token] = nil
      cookies[:remember_token] = nil
      gflash :now,:success => "Logged Out Successfully"
      redirect_to root_url
    else
      gflash :now,:success => "Logged Out Successfully"
      redirect_to root_url      
    end
  end
end
