Feature: Technologies

  Scenario: a employee visits technology page
    Given user is employee
    And a user visits the technology form
     Then they should see an error message
     And page should have content Not Authorized

  Scenario: a project manager visits technology page
    Given user is project manager
    And a user visits the technology form
     Then they should see an error message
     And page should have content Not Authorized

  @javascript
  Scenario: a admin visits technology page
    Given user is admin
    And a user visit the profile page
      And user clicks link Extra
        Then page should have content Add Technology
        When user clicks link Add Technology
        Then page should have title Technologies
          And page should have content Add Technology
          And page should have button Create Technology
          And page should have content List of Technologies
        When the user submits invalid technology information
      Then they should see an error message beside text box
        And page should have content can't be blank

  @javascript
  Scenario: Successful technology creation and update
    Given user is admin
      And a user visit the profile page
      And user clicks link Extra
      When user clicks link Add Technology
      And the user submits valid technology information
        Then page should have content Technology Successfully Created
        When user click on technology edit link
        Then page should have content Edit Technology
          And page should have button Update Technology
          And page should have content List of Technologies
          When the user submits invalid technology information for update
            And they should see an error message beside text box
            And page should have content can't be blank
          When the user submits valid technology information for update
            Then page should have content Technology Successfully Updated
          When user click on technology delete link
            Then user should see a Are you sure? JS confirm dialog
            When user click on Cancel
          When user click on technology delete link
            Then user should see a Are you sure? JS confirm dialog
            When user click on OK
              Then page should have content Technology Successfully deleted

