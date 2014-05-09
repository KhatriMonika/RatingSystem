class ReportsController < ApplicationController
  before_action :check_team_present
  def index 
  	params[:startdate].present? ? @startdate = params[:startdate] : @startdate = Date.today - 1
  	params[:enddate].present? ? @enddate = params[:enddate] : @enddate = Date.today - 1
    if current_user.employee?
      @selected_employees = Employee.where(id: current_user.id)
    else
  	  params[:employees].present? ? @selected_employees = Employee.where(id: params[:employees]) : @selected_employees = Employee.where("role_id != ?",Role::ROLES.index("Admin"))
      teams = Team.all
      @all_employees = Hash.new
      teams.each do |team|
        if team.team_members.present?
          if team.project_manager.admin?
            @all_employees[team.name] = team.team_members.pluck("name,id")
          else
            @all_employees[team.name] = team.team_members_with_project_manager.pluck("name,id")
          end
        end
      end
    end

  	if params[:factor_id].present?
  		@selected_factors = Factor.where(id: params[:factor_id]).order(:id)
  		@rating_details = RatingDetail.joins(rating: :employee).where("(ratings.rating_date >= ? and ratings.rating_date <= ?)",@startdate,@enddate).select("ratings.rating_date as date,ratings.total_rating as total_rating,ratings.remarks as remark,employees.name as emp_name,factor_id,rating_value").where(employees: { id: @selected_employees },factor_id: params[:factor_id]).order("factor_id, ratings.rating_date").group_by(&:date)
  	else
  		@rating_details = Rating.where("(rating_date >= ? and rating_date <= ?)", @startdate, @enddate).joins("right outer join employees on employees.id = ratings.employee_id").where(employees: { id: @selected_employees }).select("ratings.rating_date, total_rating,remarks as remark,employees.name as emp_name").order(:rating_date).group_by(&:rating_date)
  	end
  	if !(@rating_details.present?)
  		 gflash :now,:notice => "Rating does not present for these employee/s on these date/s for this factor/s"
  	end
  	respond_to do |format|
  		format.html {render 'index'}
  		format.js {}
      format.xls { }
  	end
  end

  def export
    params[:startdate].present? ? @startdate = params[:startdate] : @startdate = Date.today - 1
    params[:enddate].present? ? @enddate = params[:enddate] : @enddate = Date.today - 1
    if current_user.role == "Employee"
      @selected_employees = Employee.where(id: current_user.id)
    else
      params[:employees].present? ? @selected_employees = Employee.where(id: params[:employees]) : @selected_employees = Employee.where("role_id != ?",Role::ROLES.index("Admin"))
    end
    @header = Array.new
    @header << ((@selected_employees.length == 1) ? "Date" : "Name")
    if params[:factor_id].present?
      @selected_factors = Factor.where(id: params[:factor_id]).order(:id)
      @selected_factors.each do |factor|
        @header << factor.name
      end
      @rating_details = RatingDetail.joins(rating: :employee).where("(ratings.rating_date >= ? and ratings.rating_date <= ?)",@startdate,@enddate).select("ratings.rating_date as date,ratings.total_rating as total_rating,ratings.remarks as remark,employees.name as emp_name,factor_id,rating_value").where(employees: { id: @selected_employees },factor_id: params[:factor_id]).order("factor_id, ratings.rating_date").group_by(&:date)
    else
      @rating_details = Rating.where("(rating_date >= ? and rating_date <= ?)", @startdate, @enddate).joins("right outer join employees on employees.id = ratings.employee_id").where(employees: { id: @selected_employees }).select("ratings.rating_date, total_rating,remarks as remark,employees.name as emp_name").order(:rating_date).group_by(&:rating_date)
    end
    @header << "Total_rating"
    @header << "Remarks"
    render xlsx: "export", disposition: "inline", filename: "export.xlsx"
  end
end