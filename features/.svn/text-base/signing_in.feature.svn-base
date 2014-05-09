Feature: Signing in

  Scenario: Unsuccessful signin
    Given a user visits the signin page
    When they submit invalid signin information
    Then they should see an error message
      And they should not see logout link

  Scenario: Successful signin
    Given a user visits the signin page
        When the user submits valid signin information
          And they should see profile page
          And they should see their name
          And they should see a logout link
          And they should see a dashboard link
          And they should see a view ratings link
          And they should see a date wise line chart link
          And they should not see a assign ratings link
          And they should not see a employee list link
          And they should not see a team link
          And they should not see a factor link
          And they should not see a technology link
          And they should not see a factor and date wise chart link
          And they should not see a overall performance chart link
        Given user is project manager
          And a user visits the home page
            Then they should not see a team link
              And they should not see a factor link
              And they should not see a technology link
              And they should see a assign ratings link
              And they should see a employee list link
              And they should see a factor and date wise chart link
              And they should see a overall performance chart link
        Given user is admin
          And a user visits the home page
            Then they should see a team link
              And they should see a factor link
              And they should see a technology link
              And they should see a assign ratings link
              And they should see a employee list link
              And they should see a factor and date wise chart link
              And they should see a overall performance chart link