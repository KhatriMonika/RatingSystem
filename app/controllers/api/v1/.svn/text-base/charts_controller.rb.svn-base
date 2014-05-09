class Api::V1::ChartsController < Api::V1::BaseController
   include FactorsHelper,ChartModule
   before_filter :params_check, :except => [:top_improving_employees,:rating_gauge]
   before_filter :fetch_Employee, :only => [:rating_gauge]
  def datewise_and_factorwise_employees_performance
    
    # variables used
      total_factor_value=0
      @message = ""
      @employee_value_hash = Hash.new

    # set default values for factors
      if params[:factor_id].present?
        @factorid = params[:factor_id]
      else
        @factorid = Factor.first.id
      end

    # max days
      if max_rating_entry
        @count= max_value(@factorid) * @max_rating_count
      else
        render_json({:errors => "No Ratings Present for given parameters", :status => 404}.to_json)
      end

    # for each and every employee initialize hash      
      @project_manager.team.team_members.each do |emp|         
        total_factor_value = Rating.with_rating_details(@startdate,@enddate,emp.id,@factorid.to_i).pluck("rating_value").sum
        @employee_value_hash[emp.name]=((total_factor_value.to_f/@count.to_f).round(2))
        total_factor_value=0          
      end
  end


  def employee_total_rating
    if params[:empid].present? 
      @total_rating = Rating.rating_date((Date.today-15).to_s,(Date.today-1).to_s).where("employee_id = ?",params[:empid]).pluck(:rating_date,:total_rating)
    else
      parameter_errors
    end
  end

  def top_improving_employees
    startdate = params[:startdate].present? ? params[:startdate] : Date.today - 10
    enddate = params[:enddate].present? ? params[:enddate] : Date.today
    @topratings = Hash[Rating.where("rating_date between (?) AND (?) AND employee_id NOT IN (?)",startdate,enddate,Employee.where(active: false).pluck(:id)).select("employee_id, (total_rating)").pluck(:employee_id,:total_rating).group_by(&:first).map{ |k,a| [k,a.map(&:last)] }]
    if @topratings.present?
      @top_five = Hash[@topratings.map{ |k,v| [k, v.sum] }.sort_by{ |k, v| v }.last(5).reverse]
      @last_five = Hash[@topratings.map{ |k,v| [k, v.sum] }.sort_by{ |k, v| v }.first(5)]
     @employees = Hash[Employee.where("id in (?)", @top_five.keys + @last_five.keys).pluck(:id,:name,:pic_url).map{ |x| [x.first, x]}]
    else
      render_json({:errors => "No ratings found in the selected duration", :status => 404}.to_json)
    end  
  end

  def rating_gauge
    gauge_for_rating(@employee)
    if @employee.employee?
      respond_to do |format|
        format.json { render json: {:out_of_individual => @out_of_individual.as_json,:gain_individual => @gain_individual,:max_of_month_individual => @max_of_month_individual} }
      end
    else
      respond_to do |format|
        format.json { render json: {:out_of_individual => @out_of_individual.as_json,:gain_individual => @gain_individual,:max_of_month_individual => @max_of_month_individual,:out_of_team_members => @out_of_team_members.as_json,:gain_team_members => @gain_team_members,:max_of_month_team => @max_of_month_team} }
      end
    end     
  end

  def params_check
    # date set
      if params[:startdate].present?  && params[:enddate].present? 
        @startdate = params[:startdate].to_s
        @enddate   = params[:enddate].to_s
    # if params not present than last 7 days data displayed
      else
        @startdate = (Date.today-7).to_s
        @enddate = (Date.today).to_s
      end
    
    # set default values for project manager
      if params[:pmid].present?
        @project_manager = Employee.find(params[:pmid])
        if @project_manager.present? && @project_manager.project_manager?
          if (@project_manager.team.present?)
            if @project_manager.team.team_members.length == 0
              render_json({:errors => "No Team Members for given Project Manager", :status => 404}.to_json)
            end
          else
            render_json({:errors => "No Team for given Project Manager", :status => 404}.to_json)
          end
        else
          bad_record
        end
      else
        parameter_errors
      end
  end

  def max_rating_entry
    # this method return the maximum rating days entries from employee
    @max_rating_count = (Rating.rating_date(@startdate,@enddate).group(:employee_id).count).values.max  
  end
end