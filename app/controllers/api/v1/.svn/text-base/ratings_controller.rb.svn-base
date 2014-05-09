class Api::V1::RatingsController < Api::V1::BaseController
include RatingModule
## filters	
	before_filter :params_id_validator, only: [:update, :show, :default_rating_values]
	before_filter :project_manager, only: [:index, :default_rating_values]

## Create a new record of Rating and Rating Details
	def create
		rating = Rating.new(ActiveSupport::JSON.decode(params[:rating]))
		if rating.save
			render_json({:message => "record inserted", :status => 200}.to_json)
		else
			render_json({:errors => "record not inserted", :status => 404}.to_json)	
		end
	end

## called when a project Manager loggin,  
## Provides list of team members with their ratings of last 30 days

	def index
		@project_manager = fetch_Employee
		if @project_manager.team.present?
			@team_members = @project_manager.team.team_members
			@technology = @project_manager.team.technologies.uniq
		else
			render_json({:errors => "No Team Assigned yet", :status => 404}.to_json)	
		end
	end

## Provides the rating of a said employee

	def show
		@developer = Employee.find(params[:id])
		if @developer.ratings.present?
			@ratings = @developer.ratings.where("rating_date between (?) and (?)",Date.today - 30, Date.today).order("rating_date").includes({:rating_details => :factor})
			last_rating_date = Rating.where(employee_id: @developer).maximum(:rating_date)+1
			@pending_dates=(last_rating_date..Date.today).map{ |date| date }
			@pending_dates.delete_if {|x| x.cwday == 7}
			@details = Rating.joins(:rating_details).select("rating_details.rating_value").where("rating_date > ? and employee_id = ?",last_rating_date - 9, @developer.id).select("rating_details.factor_id").group_by(&:factor_id)
			@Default_values = Hash.new
			@details.each do |key,value|
				@Default_values[key] = value.mode.rating_value
			end
		else
			render_json({:errors => "No Ratings found", :status => 404}.to_json) 
		end
	end

## Updates the Ratings of Employees if present 
## or Adds new if pending flag is set true 

	def update
		@employee = Employee.find(params[:id])
		if params[:list].present?			
			data = ActiveSupport::JSON.decode(params[:list])
			update_ratings(data,@employee)			
			render_json({:success => "Updation Successfull"}.to_json)    		
		else
			render_json({:errors => "list Parameter Missing", :status => 404}.to_json)
		end
	end

	##  Validates whether id parameter is passed
	def params_id_validator
		if !params[:id].present? 
		 		parameter_errors  
			end			
	end

	private
	def rating_params
		params.require(:rating).permit(:rating_date, :remarks, :employee_id, :rating_details_attributes => [:rating_value, :factor_id, :rating_id])
	end
end