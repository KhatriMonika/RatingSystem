Feature: Charts

  @javascript
  Scenario: a employee visits charts
    Given a user visits the factor and date wise chart
      Then they should see an error message
        And page should have content Not Authorized
    When a user visits the overall performance chart
      Then they should see an error message
        And page should have content Not Authorized
      When a user visits the date wise line chart
        Then they should see an error message
        And page should have content There is no data yet

