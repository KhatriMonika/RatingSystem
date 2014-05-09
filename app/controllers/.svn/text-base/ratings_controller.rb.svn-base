class RatingsController < ApplicationController
	include RatingModule
	def new
		@employee = Employee.friendly.find(params[:employee_id])
		@rating = Rating.new
		Factor.where("active = ?", true).find_each do |factor|
		  @rating.rating_details.build(factor_id: factor.id)
		end
	end	

	def update
		@rating = Rating.find(params[:id])
		if @rating.update_attributes(rating_params)
			updated_total_rating = @rating.rating_details.sum(:rating_value)
			@rating.update_attributes(total_rating: updated_total_rating)
			@date = @rating.rating_date
			rating_members(@rating.rating_date)
			render :js => "jQuery.gritter.add({image: '/assets/success.png',title: 'Success', text: 'Rating Updated successfully!'});"
		end
	end

	def create
		@employee = Employee.friendly.find(params[:employee_id])
		@rating = @employee.ratings.new(rating_params)
		if @rating.save
			avg_rating = @rating.rating_details.sum(:rating_value)
	  	@rating.update_attributes(total_rating: avg_rating)	        		
			redirect_to employee_ratings_path(@employee.id), :gflash => { :success =>  "Rating Assigned..!!" }
		else
			gflash :now,:error => @rating.errors.full_messages.join(',').insert(0,',').to_s.gsub(',','<br><i class= "fa fa-circle">&nbsp;</i>')
			render :action => "new"	
		end
	end

	def index
		@employee = Employee.friendly.find(params[:employee_id])
	end

	def create_mass_rate					
		if request.xhr?
			@date = params[:rating_date]				
			rating_members(@date)	
		else 
			@date = params[:date][:rating_date]
			rating_members(@date) 
			data = params[:rating]			
			@members = @new_members
			@members.each do |member|
     		rating = Rating.new(employee_id: member.id, rating_date: @date, remarks: data[member.id.to_s][:remarks], project_manager_id: data[member.id.to_s][:project_manager])
   			if rating.save
     			data[member.id.to_s]["rating_details_attributes"]["rating_values"].keys.each do |factorid|
        	 		r = rating.rating_details.new(factor_id: (factorid.to_i), rating_value: (data[member.id.to_s][:rating_details_attributes][:rating_values][factorid]))
         			if r.save
         				avg_rating = rating.rating_details.sum(:rating_value)
        				rating.update_attributes(total_rating: avg_rating)
        			end
       		end
     		end
	   	end
	   	rating_members(@date)
	   	gflash :now,:success => "Ratings Assigned"
	   	render :action => 'employee_rate'	   
		end
	end

	def employee_rate
		if current_user.team.present? || current_user.admin?
			@date = Date.today 
			rating_members(@date)
		else
			gflash :now,:error => "You are not Assigned Your Team Yet."
		end
	end

	def ratings_import		
	end

	def import
		if params[:file].present?
			if ["application/vnd.ms-excel","text/csv", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"].include? params[:file].content_type
				Rating.import(params[:file],current_user)
				gflash :now,:success =>  "Ratings Imported."
				redirect_to :back
		  else
		  	gflash :now,:error =>  "Accepted File-Formats are .xls | .xlsx | .csv."
		  	redirect_to :back
		  end
		else
			gflash :now,:error => "Empty File Please Upload a file"
	  	redirect_to :back
		end
	end

	def rating_params
   	params.require(:rating).permit(:rating_date, :remarks, :employee_id, :id, :project_manager_id, :rating_details_attributes => [:rating_value, :factor_id, :id])
  end
end