json.array!(@leaves) do |leafe|
  json.extract! leafe, :id, :date_of_application, :date_of_approval, :name, :reporting_to, :leave_required_from, :leave_required_to, :leave_options, :informed_to_client, :informed_to_team_members, :reason_of_leave, :note
  json.url leafe_url(leafe, format: :json)
end
