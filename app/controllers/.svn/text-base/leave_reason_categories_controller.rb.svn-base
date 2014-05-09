class LeaveReasonCategoriesController < ApplicationController
  before_action :check_role_admin
  before_action :set_leave_reason_category, only: [:update, :destroy,:edit]

  # GET /leave_reason_categories/new
  def new
    @leave_reason_category = LeaveReasonCategory.new
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # GET /leave_reason_categories/1/edit
  def edit
    respond_to do |format|
      format.js {}
    end
  end

  # POST /leave_reason_categories
  # POST /leave_reason_categories.json
  def create
    @leave_reason_category = LeaveReasonCategory.new(leave_reason_category_params)
    respond_to do |format|
      if @leave_reason_category.save
        gflash :now,:success => "Leave Reason Category created successfully!"        
        format.js {render :js => "window.location = 'new'"}
        format.html {}
      else
        format.js {} 
        format.html {}    
      end
    end
  end

  # PATCH/PUT /leave_reason_categories/1
  # PATCH/PUT /leave_reason_categories/1.json
  def update
    if @leave_reason_category.update(leave_reason_category_params)
      gflash :now,:success => "Leave Reason Category Successfully Updated"
      render :js => "window.location = 'new'" 
    else
      render 'edit'
    end
  end

  # DELETE /leave_reason_categories/1
  # DELETE /leave_reason_categories/1.json
  def destroy
    if @leave_reason_category.active?
      @leave_reason_category.active = false
    else
      @leave_reason_category.active = true
    end
    @leave_reason_category.save
    gflash :now,:success => "Leave Reason Category Successfully #{@leave_reason_category.status}d"
    redirect_to new_leave_reason_category_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leave_reason_category
      @leave_reason_category = LeaveReasonCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leave_reason_category_params
      params.require(:leave_reason_category).permit(:name, :colour)
    end
end
