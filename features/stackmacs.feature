Feature: Use emacs as stackoverflow client
  In order to save time browsing stackoverflow
  As a stackoverflow emacs user
  I want to connect directly to stackoverflow to browse and answer questions
  
  Scenario: Display list of recent questions on stackoverflow
    Given I turn on stackmacs-mode
    When I press "C-c C-s bq"
    Then I should see "some questions"
