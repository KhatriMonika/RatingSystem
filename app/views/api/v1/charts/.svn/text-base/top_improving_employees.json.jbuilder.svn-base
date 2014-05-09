json.Details do
  json.Top_Five_Employees @top_five.keys.each do |key|
    json.name @employees[key].second
    json.image @employees[key].last.nil? ? DOMAIN_CONFIG+"/assets/default.png" : @employees[key].last
    json.total_rating @top_five[key]
  end

  json.Last_Five_Employees @last_five.keys.each do |key|
    json.name @employees[key].second
    json.image @employees[key].last.nil? ? DOMAIN_CONFIG+"/assets/default.png" : @employees[key].last
    json.total_rating @last_five[key]
  end
end