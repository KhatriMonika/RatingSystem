Feature: Ratings

  Scenario: Visit assign rating page
    Given a user visits the assign rating page
        Then they should see an error message
          And page should have content Not Authorized