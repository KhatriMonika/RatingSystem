json.Project_managers @PM do |pm|
	json.id pm.id
	json.PMName pm.name
	json.PMImage pm.gravatar_url
	json.Team Technology.all do |tech|
		json.Technology tech.name
		json.Developers Employee.where("technology_id = ? and team_id = ?", tech.id, Team.find_by_project_manager_id(pm.id).id) do |developer|
				json.id developer.id
				json.Name developer.name
				json.Image developer.photo_image
		end
	end
end
