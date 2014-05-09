json.partial! '/api/v1/ratings/ratings'
json.Pending_Dates @pending_dates
json.Factor_ids @Default_values.keys
json.Default_values @Default_values.values