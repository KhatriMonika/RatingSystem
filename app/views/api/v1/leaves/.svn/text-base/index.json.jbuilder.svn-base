if @leaves.present?
  json.leaves @leaves do |leave|
    json.id leave.id
    json.employee do
      json.id leave.employee.id
      json.name leave.employee.name
    end
    json.date_of_application leave.date_of_application
    json.date_of_approval leave.date_of_approval
    json.required_from leave.leave_required_from
    json.required_to leave.leave_required_to
    json.options leave.option.as_json
    json.informed_to_client leave.informed_to_client
    json.reason leave.reason_of_leave
    json.note leave.note
    json.status do
      json.id leave.status
      json.name leave.status_name
    end
    json.reason_category do
      json.id leave.leave_reason_category_id
      json.name leave.leave_reason_category.name
      json.color leave.leave_reason_category.colour
    end
    json.google_event_id leave.google_leave_id
    json.my_leave "true"
  end
end

if @team_members_leaves.present?
  json.team_members_leaves @team_members_leaves do |leave|
    json.id leave.id
    json.employee do
      json.id leave.employee.id
      json.name leave.employee.name
    end
    json.date_of_application leave.date_of_application
    json.date_of_approval leave.date_of_approval
    json.required_from leave.leave_required_from
    json.required_to leave.leave_required_to
    json.options leave.option.as_json
    json.informed_to_client leave.informed_to_client
    json.reason leave.reason_of_leave
    json.note leave.note
    json.status do
      json.id leave.status
      json.name leave.status_name
    end
    json.reason_category do
      json.id leave.leave_reason_category_id
      json.name leave.leave_reason_category.name
      json.color leave.leave_reason_category.colour
    end
    json.google_event_id leave.google_leave_id
    json.my_leave "false"
  end
end