class TeamsController < ApplicationController
  ## allow only if current user is admin ##
  before_action :check_role_admin

  ## unallocated members ##
  before_action :new_members, :only => [:new,:edit,:update,:create, :unallocated_members]
  before_action :all_teams, :only => [:new,:edit,:update,:create, :index]

  ## project managers list for new team or to change team's project managers ##
  before_action :project_managers_for_new, :only => [:new,:create]
  before_action :project_managers_for_edit, :only => [:edit,:update]

  def new
    @team = Team.new
  end

  def create
    old_team = Team.friendly.find_by(project_manager_id: params[:team][:project_manager_id])
    if(old_team.present?)
      if(old_team.team_members.present?)
        old_team.team_members.update_all(team_id: nil)
      end
      old_team.destroy
    end
    @team = Team.new(team_params)
    if @team.save
      list = params[:add_to_team].split(",")
      Employee.where(id: list).update_all(team_id: @team.id)
      @team.project_manager.update_attributes(team_id: @team.id)
      gflash :now,:success => "Team Successfully created"
      redirect_to teams_path
    else
      gflash :now,:error => @team.errors.full_messages.join(',').insert(0,',').to_s.gsub(',','<br><i class= "fa fa-circle">&nbsp;</i>')
      render 'new'
    end
  end
  
  def index
  end

  def show
    @team = Team.friendly.find(params[:id])
  end

  def edit
    @team = Team.friendly.find(params[:id])
  end

  def update
    @team = Team.friendly.find(params[:id])
    old_team = Team.friendly.find_by(project_manager_id: params[:team][:project_manager_id])
    if(old_team.present? && old_team != @team)
      if(old_team.team_members.present?)
        old_team.team_members.update_all(team_id: nil)
      end
      old_team.destroy
    end
    @team.project_manager.update_attributes(team_id: nil)
    Employee.friendly.find(params[:team][:project_manager_id]).update_attributes(team_id: @team.id)
    add_list = params[:add_to_team].split(",")
    Employee.where(id: add_list).update_all(team_id: @team.id)
    remove_list = params[:remove_from_team].split(",")
    Employee.where(id: remove_list).update_all(team_id: nil)
    if @team.update_attributes(team_params)
      gflash :success => "Team Successfully Updated"
      render 'show'
    else
       gflash :now,:error => @team.errors.full_messages.join(',').insert(0,',').to_s.gsub(',','<br><i class= "fa fa-circle">&nbsp;</i>')
      render 'edit'
    end
  end

  def destroy
    @team = Team.friendly.find(params[:id])
    ## for removing members from team ##
    if (params[:info] == "Remove Member")
      Employee.friendly.find(params[:member]).update_attributes(team_id: nil)
      gflash :success => "Member Removed from team"
      render 'show'
    else
      ## To destroy team ##
      @team.destroy
      gflash :success => "Team Deleted"
      redirect_to teams_path
    end
  end

  def unallocated_members
  end

  private
  def team_params
    params.require(:team).permit(:name, :photo, :project_manager_id)
  end

  def new_members
    @unallocated_members = Employee.developers.unallocated_members
  end

  def project_managers_for_new
    @project_managers_for_new_team = Employee.project_managers_and_admin
  end

  def project_managers_for_edit
    @project_managers_for_new_team = Array.new
    @project_managers_for_new_team << Team.friendly.find(params[:id]).project_manager
    Employee.project_managers_and_admin.where("id != ?",Team.friendly.find(params[:id]).project_manager_id).each do |project_manager|
      @project_managers_for_new_team << project_manager
    end
  end

  def all_teams
    @teams = Team.all
  end
end
