When /^the user submits invalid technology information$/ do
  click_button "Create Technology"
end

When /^the user submits invalid technology information for update$/ do
  fill_in "technology_name", with: ""
  click_button "Update Technology"
end

When /^they should see an error message beside text box$/ do
  expect(page).to have_selector('span.help-inline')
end

When /^the user submits valid technology information$/ do
  fill_in "technology_name",    with: "xyz"
  click_button "Create Technology"
end

When /^the user submits valid technology information for update$/ do
  fill_in "technology_name",    with: "abc"
  click_button "Update Technology"
end

When /^user click on technology edit link$/ do
  find('a.btn-warning').click
end

When /^user click on technology delete link$/ do
  find('a.btn-danger').click
end