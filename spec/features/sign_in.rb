require "spec_helper"

feature "Signin" do
  before do
    visit '/sessions/new'
  end
  it "email and password blank", :js => true do
    fill_in "User Name", :with => ""
    fill_in "Password", :with => ""
    click_button "Sign in Using Google"
    expect(page).to have_title("AccuRate | Login Page")
    expect(page).to have_text("Email can't be Blank.")
    expect(page).to have_text("Password can't be Blank.")
  end

  describe "email or password blank" do
    it "email is blank", :js => true  do
      fill_in "User Name", :with => ""
      fill_in "Password", :with => "test"
      click_button "Sign in Using Google"
      expect(page).to have_title("AccuRate | Login Page")
      expect(page).to have_text("Email can't be Blank.")
    end

    it "password is blank", :js => true  do
      fill_in "User Name", :with => "test"
      fill_in "Password", :with => ""
      click_button "Sign in Using Google"
      expect(page).to have_title("AccuRate | Login Page")
      expect(page).to have_text("Password can't be Blank.") 
    end
  end

  it "email or password will be wrong", :js => true do
    fill_in "User Name", :with => "ankita"
    fill_in "Password", :with => "ankita"
    click_button "Sign in Using Google"
    expect(page).to have_title("AccuRate | Login Page")
    expect(page).to have_text("Authorization Failed")
  end

  it "when details are true", :js => true do
    fill_in "User Name",    :with => "ankita"
    fill_in "Password", :with => "13/11/1990ankita"
    click_button "Sign in Using Google"
    expect(page).to have_title("AccuRate | Profile")
  end

end
