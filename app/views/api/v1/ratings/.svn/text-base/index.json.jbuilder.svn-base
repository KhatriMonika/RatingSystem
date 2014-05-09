json.Team @technology.each do |tech|
  json.Technology tech.name
  json.Developers @team_members.with_technology(tech.id).each do |developer|
 		json.id developer.id
	  json.Name developer.name
	  json.Image developer.gravatar_url
    json.Technology tech.name		
  end
end