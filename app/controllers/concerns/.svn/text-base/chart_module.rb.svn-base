module ChartModule
  def datewise_employees_line_chart(start_date,end_date,factor_id,project_manager)
  # if All is selected than total_rating should be display
    if factor_id == '0' 
      if current_user.employee?
        Rating.employee_with_total_rating(start_date, end_date).where("employees.role_id != 1 and ratings.employee_id = ?", current_user.id).order("ratings.rating_date").group_by(&:emp_name)
      else
        Rating.employee_with_total_rating(start_date, end_date).where("employees.role_id != 1 and team_id = ?", project_manager.team_id).order("ratings.rating_date").group_by(&:emp_name)      
      end
  # else selected factor result should be display
    else
      if current_user.employee?
        Rating.employee_with_factor_value(start_date, end_date).where("employees.role_id != 1 and rating_details.factor_id = ? and ratings.employee_id = ?",factor_id,current_user.id).order("ratings.rating_date").group_by(&:emp_name)      
      else
        Rating.employee_with_factor_value(start_date, end_date).where("employees.role_id != 1 and team_id = ? and rating_details.factor_id = ?", project_manager.team_id,factor_id).order("ratings.rating_date").group_by(&:emp_name)      
      end
    end  
  end
  # Data of Employees whose performance is Improving and degrading #
  def top_improving_degrading_data(start_date,end_date)
    @start_date = start_date.present? ? start_date : Date.today - 30
    @end_date = end_date.present? ? end_date : Date.today 
    @topratings = Hash[Rating.where("rating_date between (?) AND (?) AND employee_id NOT IN (?)",@start_date,@end_date,Employee.where(active: false).pluck(:id)).select("employee_id, (total_rating)").pluck(:employee_id,:total_rating).group_by(&:first).map{ |k,a| [k,a.map(&:last)] }]
    @top_five = Hash[@topratings.map{ |k,v| [k, v.sum] }.sort_by{ |k, v| v }.last(5).reverse]
    @last_five = Hash[@topratings.map{ |k,v| [k, v.sum] }.sort_by{ |k, v| v }.first(5)]
    @employees = Hash[Employee.where("id in (?)", @top_five.keys + @last_five.keys).pluck(:id,:name)]
    @top_five_data = @top_five.map{|key,value| [@employees[key],value]}
    @last_five_data = @last_five.map{|key,value| [@employees[key],value]}
  end

  def gauge_for_rating(current_user)
    factor_max_value = FactorGuidline.maxofday
    @max_of_month_individual = @max_of_month_team = factor_max_value * Date.today.end_of_month.day
  
    if current_user.admin?
      @status_individual = true
      result =  Rating.all_employee_current_month_rating
      if result
        @out_of_individual  = Date.today.day * factor_max_value * Employee.active_employee.count
        @gain_individual = result.sum
      else
        @out_of_individual = @gain_individual  = 0
      end
      @max_of_month_individual *=  (Employee.active_employee.count)     
    else
      result = current_user.employee_current_month_rating
      @status_individual = result.any?
      if @status_individual
        @out_of_individual  = Date.today.day * factor_max_value
        @gain_individual = result.sum
      else
        @out_of_individual = @gain_individual  = 0
      end
    end   

    result = current_user.team_members_current_month_rating
    if current_user.team_present? && result.any?
      @gain_team_members  = result.sum + ( current_user.admin? ? Employee.project_managers_current_month_rating.sum : 0 )
      total_members = (current_user.admin? ? Employee.project_managers.count + current_user.team.team_members.count  :  current_user.team.team_members.count )
      @max_of_month_team *= total_members
      @out_of_team_members = Date.today.day * factor_max_value * total_members
    else
      @gain_team_members = @out_of_team_members = 0
    end
  end

  def leave_pie_chart_data(startDate,endDate,status,reason_category,employees)
    @details = Leave.leaves_on_dates(startDate,endDate).leave_status(status).leaves_of_reason_category(reason_category).selected_employee_leaves(employees).joins(:leave_reason_category,:employee).select("employees.name as name,leave_reason_categories.name as category,leaves.leave_options as options,leaves.status as status,leaves.leave_required_from  as date_from,leaves.leave_required_to as date_till,leaves.reason_of_leave as reason").group_by(&:name)
  end

  def regularity_of_employees(startDate,endDate)
    @start_date_leave = startDate.present? ? startDate : Date.today - 15
    @end_date_leave = endDate.present? ? endDate : Date.today + 15
    @regular_employees_name = Employee.where("id NOT IN (?) AND role_id != ? AND active = ?", Leave.leaves_on_dates(@start_date_leave,@end_date_leave).leave_status(Leave::STATUS.index("Sanctioned")).pluck("employee_id").uniq,0,true).pluck("name")
    @leaves = Leave.leaves_on_dates(@start_date_leave,@end_date_leave).leave_status(Leave::STATUS.index("Sanctioned")).joins(:employee).where("employees.active = ? ",true).select("leaves.leave_options as options,employees.name as name").group_by(&:name)
    @data_for_irregular = Hash.new
    if(@regular_employees_name.empty?)
      @data = Hash.new
    end
    @leaves.each do |key,value|
      days = 0
      value.each do |v|
        days = days + v.options.split(',').length
      end
      if days > 3
        @data_for_irregular[key] = days
      end
      if(@regular_employees_name.empty? && days < 3)
        @data[key] = days
      end
    end
    @irregular_employees = @data_for_irregular.sort_by{ |k, v| v }.last(3).reverse
    if @regular_employees_name.present?
      data_for_regular = Hash.new
      count = 1
      @regular_employees_name.each do |employee|
        data_for_regular[employee] = count
        count = count + 1
      end
      @flag = true
      @regular_employees = data_for_regular.sort_by{ |k, v| v }.reverse
    else
      @flag = false
      @regular_employees = @data.sort_by{ |k, v| v }.reverse
    end
    if @irregular_employees.empty? && @regular_employees.empty?
      @message = "No employee is on leave in given duration"
    elsif @irregular_employees.empty?
      @message = "No Irregular(more thn 3 days leave) Regular"
    end
  end

  def leave_reason_category_comparison_data(startDate,endDate)
    if current_user.employee?
      @leaves = Leave.leaves_on_dates(startDate,endDate).leave_status(0).selected_employee_leaves(current_user.id).joins(:leave_reason_category).select("leaves.leave_options as options, leave_reason_categories.name as category").group_by(&:category)
    else
      @leaves = Leave.leaves_on_dates(startDate,endDate).leave_status(0).joins(:leave_reason_category).select("leaves.leave_options as options, leave_reason_categories.name as category").group_by(&:category)
    end
    @data = Hash.new
    @leaves.each do |key,value|
      days = 0
      value.each do |v|
        days = days + v.options.split(',').length
      end
      @data[key] = days
    end
  end
end