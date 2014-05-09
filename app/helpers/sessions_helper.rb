module SessionsHelper
  include Google,ActionView::Helpers::UrlHelper
  def user_signed_in
    if !session[:token].present? 
      gflash :now,:error => "Sign in First"
      redirect_to root_path
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == @current_user
  end

  def current_user
    token = cookies[:remember_token].present? ? cookies[:remember_token] : session[:token]
    if token.present?
      @current_user ||= Employee.find(AccessKey.find_by_access_token(token).employee_id)
    end
  end

  def token_validity
    token = cookies[:remember_token].present? ? cookies[:remember_token] : session[:token]
    if  !AccessKey.find_by_access_token(token).present?
      session[:token] = nil
      cookies[:remember_token] = nil
    end 
  end
end