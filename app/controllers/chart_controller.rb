class ChartController < ApplicationController
  include FactorsHelper,ChartModule
  before_action :check_role_not_employee, only: [:datewise_and_factorwise_employees_performance, :overall_employee_impression,:top_employees,:employee_yesterday_rating]
  before_action :check_team_present,:params_check
  skip_before_action :check_team_present,:params_check, only: [:leaves_pie,:most_regular_irregular_employees, :leave_reason_category_comparison]

  def line_chart
    # set default values for factors
      if params[:factor_id].present?
        @factor_id = params[:factor_id]
      else
        @factor_id = '0'
      end
    @ratings = datewise_employees_line_chart(@start_date,@end_date,@factor_id,@project_manager)
  end



  def overall_employee_impression
    # employess factors rating value grouped 
      @rating_details = RatingDetail.joins("inner join ratings on ratings.id = rating_details.rating_id inner join employees on employees.id = ratings.employee_id inner join factors on factors.id = rating_details.factor_id").
                      where("ratings.rating_date >= ? and ratings.rating_date <= ? and team_id = ?",@start_date,@end_date,@project_manager.team_id).
                      select("employees.name as emp_name, factor_id, sum(rating_details.rating_value) as total_rating, ratings.employee_id as employee_id, factors.name as factor_name").
                      group("factor_id, ratings.employee_id").
                      group_by(&:factor_name)
      max_rating_entry
  end   
 


  def top_employees
    @employees = Rating.rating_date("2014-01-01","2014-03-19").joins("right outer join employees on employees.id = ratings.employee_id").where("employees.role_id!=1").group("employees.name").sum("ratings.total_rating").sort_by{|k,v| v}.reverse
  end

  def top_improving_degrading_employees
    top_improving_degrading_data(@start_date,@end_date)
  end

  def leaves_pie
    @status = params[:status].present? ? params[:status] : [0,1]
    @reason_category = params[:reason_category].present? ? LeaveReasonCategory.where(id: params[:reason_category]) : LeaveReasonCategory.all
    @startDate = params[:startdate].present? ? params[:startdate] : Date.today
    @endDate = params[:enddate].present? ? params[:enddate] : Date.today + 30
    if current_user.employee?
      @employees = current_user.id
    else
      @employees = params[:employees].present? ? params[:employees] : Employee.all.pluck("id")
      @all_employees = Hash.new
      Team.all.each do |team|
        if team.team_members.present?
          if team.project_manager.admin?
            @all_employees[team.name] = team.team_members.pluck("name,id")
          else
            @all_employees[team.name] = team.team_members_with_project_manager.pluck("name,id")
          end
        end
      end
      @all_employees["Unallocated"] = Employee.unallocated_members.pluck("name","id")
    end
    leave_pie_chart_data(@startDate,@endDate,@status,@reason_category,@employees)
    respond_to do |format|
      format.html {render 'leaves_pie'}
      format.js {  }
    end
  end

  def most_regular_irregular_employees
    @startDate = params[:startdate].present? ? params[:startdate] : Date.today - 15
    @endDate = params[:enddate].present? ? params[:enddate] : Date.today + 15
    regularity_of_employees(@startDate,@endDate)
    respond_to do |format|
      format.html { }
      format.js { }
    end
  end

  def leave_reason_category_comparison
    @startDate = params[:startdate].present? ? params[:startdate] : Date.today - 15
    @endDate = params[:enddate].present? ? params[:enddate] : Date.today + 15
    leave_reason_category_comparison_data(@startDate,@endDate)
    respond_to do |format|
      format.html { }
      format.js { }
    end
  end

  private
  def params_check
    # date set
      if params[:startdate].present?  && params[:enddate].present? 
        @start_date = params[:startdate]
        @end_date   = params[:enddate]
    # if params not present than last 7 days data displayed
      else
        @start_date=(Date.today-7 ).to_s
        @end_date=(Date.today).to_s
      end
    
    # set default values for project manager
      if params[:project_manager_id].present?
        @project_manager = Employee.friendly.find(params[:project_manager_id])
      elsif current_user.project_manager? && current_user.team.present? && current_user.team.team_members.present?
        @project_manager = current_user
      else
        @project_manager =  Employee.project_managers.joins([:team]).first
      end
  end

  def max_rating_entry
    # this method return the maximum rating days entries from employee
    @max_rating_count = (Rating.rating_date(@start_date,@end_date).group(:employee_id).count).values.max 
    @max_rating_count.present? ? @max_rating_count : nil   
  end
end

