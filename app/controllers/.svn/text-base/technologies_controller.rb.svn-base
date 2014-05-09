class TechnologiesController < ApplicationController
	before_action :check_role_admin
	def new
		@technology = Technology.new
		respond_to do |format|
  		format.js {}
  		format.html {}
  	end
	end

	def edit
		@technology = Technology.find(params[:id])
		respond_to do |format|
  		format.js {}
  	end
	end 

	def create
		@technology = Technology.new(technology_params)
		respond_to do |format|
			if @technology.save
				gflash :now,:success => "Technology created successfully!"				
				format.js {render :js => "window.location = 'new'"}
				format.html {}
			else
	  		format.js {} 
	  		format.html {} 		
			end
		end
	end

	def update
		@technology = Technology.find(params[:id])
		if @technology.update_attributes(technology_params)
			gflash :now,:success => "Technology Successfully Updated"
			render :js => "window.location = 'new'"	
		else
			render 'edit'
		end  		
	end

	def destroy
		@technology = Technology.find(params[:id])
=begin
		Employee.where("technology_id = ?",@technology.id).each do |emp|
			emp.update_attributes(technology_id: nil)
		end
=end

		@technology.destroy
		gflash :now,:success => "Technology Successfully deleted"
		redirect_to new_technology_path
	end

	private
	def technology_params
		 params.require(:technology).permit(:name)
	end
end