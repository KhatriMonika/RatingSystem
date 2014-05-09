json.Project_Managers @members.each do |projet_manager|
  json.Project_Manager_Id projet_manager.id
  json.Project_Manager_Name projet_manager.name
  json.Project_Manager_Photo projet_manager.gravatar_url
  if projet_manager.team.present?
   	json.Team_Name projet_manager.team.name
  	json.Team_Members_Count projet_manager.team.team_members.count
  end
end