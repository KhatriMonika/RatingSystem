include Google

When /^they submit invalid signin information$/ do
  click_button "Sign in Using Google"
end

Then /^they should not see logout link$/ do
  expect(page).not_to have_link('Log Out', href: logout_path)
end


When /^the user submits valid signin information$/ do
  fill_in "employee_email",    with: "monika"
  fill_in "employee_password", with: "123monika"
  click_button "Sign in Using Google"
end

When /^a user visit the profile page$/ do
  visit employee_path($current_user)
end

Then /^they should see profile page$/ do
  expect(page).to have_title("AccuRate | Profile")
end

Then /^they should see their name$/ do
  expect(page).to have_content(current_user.name.upcase)
end

Then /^they should see a logout link$/ do
  expect(page).to have_link("Log Out", href: logout_path)
end

Then /^they should see a dashboard link$/ do
  expect(page).to have_link('Dashboard', href: chart_employee_yesterday_rating_path)
end

Then /^they should see a view ratings link$/ do
  expect(page).to have_link('View Ratings', href: reports_path)
end

Then /^they should see a date wise line chart link$/ do
  expect(page).to have_link('Date Wise Line chart', href: chart_datewise_employees_line_chart_path)
end

Then /^they should see a assign ratings link$/ do
  expect(page).to have_link('Rate Employees', href: employeerate_path)
end

Then /^they should not see a assign ratings link$/ do
  expect(page).not_to have_link('Rate Employees', href: employeerate_path)
end

Then /^they should see dashboard page$/ do
  expect(page).to have_title("AccuRate | Employee Yesterday Rating Chart")
end

Then /^they should see a team link$/ do
  expect(page).to have_link('Team', href: team_index_path)
end

Then /^they should not see a team link$/ do
  expect(page).not_to have_link('Team', href: team_index_path)
end

Then /^they should see a employee list link$/ do
  expect(page).to have_link('Employees List', href: employee_index_path)
end

Then /^they should not see a employee list link$/ do
  expect(page).not_to have_link('Employees List', href: employee_index_path)
end

Then /^they should see a factor link$/ do
  expect(page).to have_link('Add Factor', href: new_factor_path)
end

Then /^they should not see a factor link$/ do
  expect(page).not_to have_link('Add Factor', href: new_factor_path)
end

Then /^they should see a technology link$/ do
  expect(page).to have_link('Add Technology', href: new_technology_path)
end

Then /^they should not see a technology link$/ do
  expect(page).not_to have_link('Add Technology', href: new_technology_path)
end

Then /^they should see a factor and date wise chart link$/ do
  expect(page).to have_link('Factor&Date Wise', href: chart_datewise_and_factorwise_employees_performance_path)
end

Then /^they should not see a factor and date wise chart link$/ do
  expect(page).not_to have_link('Factor&Date Wise', href: chart_datewise_and_factorwise_employees_performance_path)
end

Then /^they should see a overall performance chart link$/ do
  expect(page).to have_link('Overall Performance', href: chart_overall_employee_impression_path)
end

Then /^they should not see a overall performance chart link$/ do
  expect(page).not_to have_link('Overall Performance', href: chart_overall_employee_impression_path)
end