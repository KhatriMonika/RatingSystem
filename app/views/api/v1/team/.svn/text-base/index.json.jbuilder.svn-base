json.complitech do
	json.id "nil"
	json.PMName "Complitech"
	json.PMImage @complitech_image
	json.Team Technology.all do |tech|
		json.Technology tech.name
		json.Developers Employee.developers.unallocated_members.with_technology(tech.id) do |developer|
				json.id developer.id
				json.Name developer.name
				json.Image developer.gravatar_url
		end
	end
end

json.Project_managers @project_managers do |pm|
	json.team_id pm.team_id
	json.id pm.id
	json.PMName pm.name
	json.PMImage pm.gravatar_url
	json.PMTeamName pm.team.name
	json.Team @technologies do |tech|
		json.Technology tech.name
		json.Developers pm.team.team_members.with_technology(tech.id).includes(:ratings) do |developer|
			json.id developer.id
			json.Name developer.name
			json.TName tech.name
			json.Image developer.gravatar_url
			if developer.ratings.present?
				json.Ratings developer.ratings.where("rating_date between (?) and (?)",Date.today - 30, Date.today).order("rating_date").includes({:rating_details => :factor}).each do |rating|
					json.Rating_Date rating.rating_date
					json.Rating_remark rating.remarks
					json.Total_rating rating.total_rating
					if rating.rating_details.present?
						json.Rating rating.rating_details.each do |details|
							json.Factor_name details.factor.try(:name)
							json.rating details.rating_value
						end
					end
				end
			end			
		end
	end
end
