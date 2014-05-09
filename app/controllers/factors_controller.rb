class FactorsController < ApplicationController
before_action :check_role_admin
	def new
		@factor = Factor.new    
    @factor.factor_guidlines.build unless @factor.factor_guidlines.present?
	end

	def create
   	@factor = Factor.new(factor_params)
		if @factor.save
      @factor.factor_notification("New Factor #{@factor.name} is added")
      redirect_to new_factor_path
      gflash :success => 'Factor is Successfully Created.' 
		else
			redirect_to new_factor_path 
      gflash :now,:error => @factor.errors.full_messages.join(',').insert(0,',').to_s.gsub(',','<br><i class= "fa fa-circle">&nbsp;</i>')
		end
	end

	def edit
		@factor = Factor.friendly.find(params[:id])
		respond_to do |format|
  		format.js {}
  		format.html{}
  	end
	end

	def update
		@factor = Factor.friendly.find(params[:id])
		if @factor.update_attributes(factor_params)
      @factor.factor_notification("Factor #{@factor.name} is Updated")
  		gflash :success => "Factor Successfully Updated"
  		redirect_to new_factor_path
  	else
  		gflash :now,:error => @factor.errors.full_messages.join(',').to_s.gsub(',','<br>')
  		render :action => 'edit'
  	end
	end

	def index
		@factor = Factor.all
	end

	def destroy
		@factor = Factor.friendly.find(params[:id])
		@factor.toggle_state
		@factor.save
    gflash :success => "Factor #{@factor.name} and its guidlines has been #{@factor.active ? 'Activated' : 'Deactivated'}"
		redirect_to new_factor_path
	end

  def destroy_factor_guidline
    @factor_guidline = FactorGuidline.find(params[:id])
    factor_id = @factor_guidline.factor_id
    @factor = Factor.find(factor_id)
    @factor_guidline.state_toggle
    @factor.factor_notification("Guidline #{@factor_guidline.description} is #{@factor_guidline.active ? "Activated" : "Deactivated"} from #{@factor.name}")
    if request.xhr?
      render :js => "window.location = '#{edit_factor_path(factor_id)}'"
    else
      redirect_to new_factor_path
    end
  end

	private
	def factor_params
		 params.require(:factor).permit(:name,factor_guidlines_attributes: [:description,:value, :id, :_destroy])
	end 
end
 