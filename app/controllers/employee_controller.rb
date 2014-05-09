class EmployeeController < ApplicationController  
  include FactorsHelper,GoogleCalendarClientModule
  before_action :fetch_employee, :except => [:index,:lock_screen]
  before_action :find_known_technologies, only: [:update,:edit,:change,:configure]
  before_action :check_role_not_employee, only: [:index]
  before_action :update_google_token , only: [:update]
  
  def update
    if params[:employee][:birthdate].present? && !(@employee.birthdate.present? &&  @employee.birthdate == params[:employee][:birthdate].to_date)
      sync_employee_birthdate_with_google("birthday of "+current_user.name, current_user, params[:employee][:birthdate]) 
    end
    if params[:employee][:joining_date].present? && !(@employee.joining_date.present? &&  @employee.joining_date == params[:employee][:joining_date].to_date)
     sync_employee_joining_date_with_google("joining of "+current_user.name, current_user, params[:employee][:joining_date]) 
    end
 
  	@employee.update_attributes(emp_params)
=begin
    @employee.known_technology_id = ""
    if params[:known_technology_id].present?
      params[:known_technology_id].each do |tech|
          @employee.known_technology_id = @employee.known_technology_id + tech + "," if tech !=params[:known_technology_id].first
      end
    end
=end

    if @employee.save
      gflash :now,:success => "Details Updated Successfully."
  		redirect_to employee_path(@employee.slug)
  	else
      gflash :now,:error => @employee.errors.full_messages.join(',').insert(0,',').to_s.gsub(',','<br><i class= "fa fa-circle">&nbsp;</i>')       
  		render :action => 'edit'
  	end
  end

  def edit
    if !(current_user.id == @employee.id) && !current_user.admin?
       gflash :error => "You cannot edit others profile"
       redirect_to edit_employee_path(current_user.slug)
    end
  end

  def index  
    @ratings = Hash[Rating.where("rating_date between (?) AND (?) AND employee_id NOT IN (?)",(Date.today - 7),Date.today,Employee.where(active: false).pluck(:id)).select("employee_id, (total_rating)").pluck(:employee_id,:total_rating).group_by(&:first).map{ |k,a| [k,a.map(&:last)] }]
    if current_user.admin? || current_user.project_manager?
      if !(params.keys.first == "action")
        if params[:active].present?
          @employee =  Employee.where("#{params.keys.first} = #{params.values.first} ")          
        else
          @employee =  Employee.where("active = true and #{params.keys.first} = #{params.values.first} AND id != (?)",current_user.id)
        end
        if !(@employee.present?)
          gflash :now,:error => "Employee in thi category not Present"       
        end
      else
        @employee = Employee.where("active = true AND id != (?)",current_user.id)
      end      
    else
      @employee = Employee.where("active = true")
    end
    
  end

  def configure
     role = @employee.role
     if @employee.update_attributes(emp_params)
      if @employee.role != role 
          team = @employee.team
          if team.present?
            members = team.team_members
            members.update_all(team_id: nil)
            @employee.team.destroy         
          end          
          if @employee.admin?
            redirect_to  employee_index_path , :gflash => { :success => "#{@employee.name} is Admin.!" }  
          elsif @employee.project_manager?
            redirect_to new_team_path , :gflash => { :success =>  "Please create a team for #{@employee.name}" }
          else
            redirect_to employee_index_path , :gflash => { :success =>  "#{@employee.name} is Employee.!" }
          end
      else
        redirect_to employee_index_path
      end
    else
       gflash :now,:error => @employee.errors.full_messages.join(',').insert(0,',').to_s.gsub(',','<br><i class= "fa fa-circle">&nbsp;</i>')       
      render :action => 'edit'
    end
  end

  def show
  end

  def toggle_active
    @employee.toggle_state
    gflash :now,:success => "Employee #{@employee.name} is #{@employee.active ? 'Activated' : 'Disabled' }"
    redirect_to employee_index_path
  end

  def change
    if current_user.project_manager? && !(@employee.team == current_user.team) || current_user.employee?
      gflash :now,:error => "You are Unauthorized For this Action..!"
      redirect_to current_user.employee? ? employee_path(current_user.slug) : employee_index_path      
    end
  end

  private

    def emp_params
    	 params.require(:employee).permit(:name, :role_id, :team_id, :technology_id, :avg_rating, :joining_date, :birthdate,:known_technology_id)
    end

    def fetch_employee
      @employee = Employee.friendly.find(params[:id])
    end

    def find_known_technologies
      @known_technologies = @employee.known_technologies
    end

    def validate_employee_access 
      if !(current_user == @employee && current_user.employee?)
        redirect_to employee_path(current_user.slug) 
      end
    end
end


