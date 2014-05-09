class Api::V1::FactorController < Api::V1::BaseController
  before_action :admin
  before_action :set_factor, only: [:update, :factor_state_toggle]
  
  def create
    @factor = Factor.new(ActiveSupport::JSON.decode(params[:factor]))
    if @factor.save
      @factor.factor_notification("New Factor #{@factor.name} is added")
      render_json({:message => "factor successfully created", :status => 200}.to_json)    
    else     
      render_json({:errors => @factor.errors.full_messages, :status => 404}.to_json)
    end
  end

  def update
    if @factor.present?
      if @factor.update_attributes(ActiveSupport::JSON.decode(params[:factor]))
        @factor.factor_notification("Factor #{@factor.name} is Updated")
        render_json({:message => "Factor Successfully Updated", :status => 200}.to_json)         
      else
        render_json({:errors => @factor.errors.full_messages, :status => 404}.to_json)        
      end
    else
      bad_record
    end
  end

	def index
	  @factors = Factor.select("id,name,active")
  end

  def factor_state_toggle
    if @factor.present?
      @factor.toggle_state
      render_json({:message => "Factor #{@factor.name}, and its Guidlines are successfully #{@factor.state}", :status => 200}.to_json)
    else
      bad_record
    end
  end

  def deactivate_guideline
    @factor_guidline = FactorGuidline.find(params[:id]) if params[:id].present?
    if @factor_guidline.present?
      @factor_guidline.update_attributes(active: !@factor_guidline.active)
      render_json({:message => "Factor Guideline #{@factor_guidline.description} has been #{@factor_guidline.active ? 'Activated' : 'Deactivated'}", :status => 200}.to_json)
    else
      bad_record
    end
  end

  private
  def set_factor
    @factor = Factor.find(params[:id]) if params[:id].present?
  end
end