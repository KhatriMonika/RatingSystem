json.Factors @factors.each do |factor|
	json.id factor.id
	json.name factor.name
  json.factor_guidlines_ids factor.factor_guidlines.pluck("factor_guidlines.id")
	json.possible_values factor.factor_guidlines.pluck(:value)
  json.guidlines factor.factor_guidlines.pluck(:description)
  json.guidlines_state factor.factor_guidlines.pluck(:active)
	json.state factor.active
end