json.auth_token  @employee.access_keys.last.access_token
json.role @employee.role
json.name @employee.name
json.birthdate @employee.birthdate
json.joining_date @employee.joining_date
json.technology @employee.tech
json.email @employee.email
json.photo_url @employee.gravatar_url

if @ratings.present?
	json.partial! '/api/v1/ratings/ratings'
else
	json.Ratings
end