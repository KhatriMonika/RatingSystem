class Api::V1::TeamController < Api::V1::BaseController
	before_filter :admin

	#list all teams along with all team members and unallocated members technology wise
	def index
		#url of complitech logo image
		@complitech_image = "#{DOMAIN_CONFIG}/assets/logo_cspl.png"
		#list of all technology
		@technologies = Technology.all
		#list of project managers whose team is present
		@project_managers = Employee.project_managers_with_team.select("employees.*,teams.name as tname")
		if !@project_managers.present?
			bad_record
		end
	end

	def create
    @team = Team.new(team_params)
    if @team.save
      @team.project_manager.update_attributes(team_id: @team.id,role_id: Role::ROLES.index("Project Manager"))
      render_json({:success => "Team Successfully Created"}.to_json)
    else
    	parameter_errors
    end
	end

	#employees can be move from one team to another team and also employees can be removed from team
	def add_member
		#list is provided in json form as params.
		if params[:list].present?
			#to check wether any bad record provided or not 
			flag = false
			ActiveSupport::JSON.decode(params[:list])["ChangedTeam"].each do |emp|
				#one employee from list params whose team needs to be chenged 
				employee = Employee.find(emp["Developer"])
				if emp["ToPM"] == "nil" && employee.present?
					employee.update_column :team_id, nil
					flag = true
				else
					newTeam = Team.find_by_project_manager_id(emp["ToPM"])
					if employee.present? && newTeam.present?
						employee.update_attributes(team_id: newTeam.id)
						flag = true
					else
						flag = false
						break
					end
				end
			end
			if flag
				render_json({:success => "Successfully Updated"}.to_json)
			else
				bad_record
			end
		else
			parameter_errors
		end
	end

	def update
		@team = Team.find(params[:id])
		@team.project_manager.update_attributes(team_id: nil)
		if @team.update_attributes(team_params)
			@team.project_manager.update_attributes(team_id: @team.id,role_id: Role::ROLES.index("Project Manager"))
      render_json({:success => "Team Successfully Updated"}.to_json)
		else
			parameter_errors
		end
	end

	def project_manager_for_new_team
		@project_managers_for_new_team = Employee.where("(role_id = ? AND team_id is null) OR role_id = ? ",1,2)
	end

	private
	def team_params
		params.require(:team).permit(:name,:project_manager_id)
	end
end