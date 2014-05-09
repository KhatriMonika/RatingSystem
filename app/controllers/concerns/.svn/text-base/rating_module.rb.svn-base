module RatingModule
  include SessionsHelper
  
  def rating_members(rating_date)
    onleave = Leave.leaves_on_date(rating_date).pluck(:employee_id)
    @factor = Rating.find_by(rating_date: rating_date).present? ? Rating.factor_active_on_date(rating_date) : Factor.available
    if current_user.admin?      
      if current_user.team_id.present?
        @members = Employee.admin_members_to_rate(current_user.team_id)
        @fetched_ratings = Rating.list_update_ratings_for_members(@members,rating_date)  
        @new_members = Employee.admin_members_to_rate(current_user.team_id).except_employees(@fetched_ratings.pluck(:employee_id) + onleave) if @fetched_ratings.present?
        if !@fetched_ratings.present?
          @new_members = onleave.present? ? @members.except_employees(onleave) : @members
        end
      else
        @fetched_ratings = Rating.list_update_ratings_for_members(Employee.project_managers,rating_date)
        @new_members = Employee.project_managers.except_employees((@fetched_ratings.pluck(:employee_id) + onleave)) if @fetched_ratings.present?
        if !@fetched_ratings.present? 
          @new_members = onleave.present? ? Employee.project_managers.except_employees(onleave) : Employee.project_managers
        end       
      end       
    else
      @fetched_ratings = Rating.list_update_ratings_for_members(current_user.team.team_members,rating_date)
      @valid_fetched_ratings = @fetched_ratings.where(project_manager_id: current_user.id) if @fetched_ratings.present?
      @new_members = current_user.team.team_members.except_employees((@fetched_ratings.pluck(:employee_id) + onleave)) if @fetched_ratings.present?
      if !@fetched_ratings.present? 
        @new_members = current_user.team.team_members
      end
    end   
  end

  def update_ratings(data, employee)  
    @employee = employee  
    data["Ratings"].each do |rating|
      r_date = rating["Rating_Date"]        
      if rating["pending"].present? 
        rating_details_attributes = []       
        rating["Rating"].each do |details|                        
          rating_details_attributes << {factor_id: details["Factor_id"], rating_value: details["rating"]}
        end
        @rating = Rating.create(rating_date: r_date, employee_id: @employee.id, remarks: rating["Rating_remark"], rating_details_attributes: rating_details_attributes)
      else            
        @rating = Rating.list_update_ratings_for_members( @employee.id,r_date).first
        rating["Rating"].each do |details|      
          f_id = details["Factor_id"]
          updted_rvalue = details["rating"]           
          @rating_details = @rating.rating_details.find_by(factor_id: f_id)
          @rating_details.update_attributes(rating_value: updted_rvalue) if @rating_details.present?         
        end
        updated_remark = rating["Rating_remark"] 
        @rating.update_attributes(remarks: updated_remark)  if updated_remark.present? 
      end
    end 
  end

  def notification_for_rating
    ## variables
    @to_be_notified_to_admin = []
    @to_be_warned = []
    ## select all project Managers who have their team
    all_project_managers = Employee.project_managers_with_team.pluck(:id)
    ## retrive project_managers on leave today
    on_leave_project_managers = Leave.leaves_on_date(Date.today).pluck(:employee_id)
    ## fetch their rating details
    @rating_details = Rating.select("project_manager_id, max(rating_date) as LastRDate").where("project_manager_id NOT IN (?)",on_leave_project_managers).group("project_manager_id").group_by(&:project_manager_id)  

    Employee.where(id: (@rating_details.keys)).each do |manager|
      ## if difference is more than 3 days then details should be sent to admin
      if (Date.today - @rating_details[manager.id].first.LastRDate) >= 3
        @to_be_notified_to_admin << manager     
      ## if difference is more than 1 day(s) then the project Manager needs to be reminded        
      elsif (Date.today - @rating_details[manager.id].first.LastRDate) >= 1
        @to_be_warned << [manager,@rating_details[manager.id].first.LastRDate]
      end
    end
  end
end

