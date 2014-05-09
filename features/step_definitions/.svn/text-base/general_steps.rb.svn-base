Given /^a (?:|user )visits (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^page should have button (.+)$/ do |button_name|
  expect(page).to have_button(button_name)
end

Then /^page should have title (.+)$/ do |title|
  expect(page).to have_title("AccuRate | #{title}")
end

Then /^user clicks link (.+)$/ do |link|
  click_link link
end

Then /^they should be able to see (.+) link with (.+)$/ do |link,href|
  expect(page).to have_link(link, href: href)
end

Then /^page should have content (.+)$/ do |content|
  expect(page).to have_content(content)
end

Then /^they should see an error message$/ do
  expect(page).to have_selector('div.alert.alert-danger')

end


Then /^should find_or_create account$/ do
  $current_user = Employee.find_or_create_by(email: "monika@complitech.net")
  $current_user.name = $current_user.email.partition('@').first if !$current_user.name.present?
  $current_user.role_id = Role::ROLES.index("Employee")
  $current_user.save!
end

Given /^user already signed in as (.+)$/ do |role|
  step "should find_or_create account"
  step 'a user visits the signin page'
  step 'the user submits valid signin information'
end

Given /^user is employee$/ do
  $current_user.update_attributes(role_id: Role::ROLES.index("Employee"))
end

Given /^user is admin$/ do
  $current_user.update_attributes(role_id: Role::ROLES.index("Admin"))
end

Given /^user is project manager$/ do
  $current_user.update_attributes(role_id: Role::ROLES.index("Project Manager"))
end

Then /^user should see a (.+) JS confirm dialog$/ do |message|
    page.driver.browser.switch_to.alert.text.should eql(message)
end

When /^user click on Cancel$/ do
  page.driver.browser.switch_to.alert.dismiss
end

When /^user click on OK$/ do
  page.driver.browser.switch_to.alert.accept
end