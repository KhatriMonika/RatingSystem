class Api::V1::EmployeeController < Api::V1::BaseController
  include GoogleCalendarClientModule
  before_action :not_employee, only: [:projectManagerIndex]
  
  def update
    @employee = fetch_Employee
    if params[:employee][:birthdate].present? && !(@employee.birthdate.present? &&  @employee.birthdate == params[:employee][:birthdate].to_date)
      sync_employee_birthdate_with_google("birthday of "+@employee.name, @employee, params[:employee][:birthdate]) 
    end
    if params[:employee][:joining_date].present? && !(@employee.joining_date.present? &&  @employee.joining_date == params[:employee][:joining_date].to_date)
     sync_employee_joining_date_with_google("joining of "+@employee.name, @employee, params[:employee][:joining_date]) 
    end
  	if @employee.update_attributes(emp_params)
      @employee.save
  		render :file => "/api/v1/employee/show.json.jbuilder"
  	else
  		render_json({:errors => "Invalid Parameters. Please try again", :status => 404}.to_json)
  	end
  end

  def show
   	  @employee = fetch_Employee
      @ratings = @employee.ratings.where("rating_date >= ?", (Date.today - 30)).order("rating_date")
  end

  def projectManagerIndex
    @admin = fetch_Employee
    @members = Employee.where("role_id = ?",1)
  end

  def upcomming_birthdays
    @birthdays = Employee.where("(extract(month from birthdate) BETWEEN ? AND ?) AND (extract(day from birthdate) BETWEEN ? AND ?)", Date.today.month, (Date.today + 7).month, Date.today.day, (Date.today + 7).day).select(:name,:birthdate,:pic_url)      
    respond_to do |format|
      format.json { render json: {:birthdays => @birthdays.as_json(only: [:birthdate, :name, :pic_url])} }
    end
  end

  private
  def emp_params
  	params.require(:employee).permit(:name)
  end
end