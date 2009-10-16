Feature: Cucumber
  In order to use cucumber conveniently
  As a developer
  I want shoe to give me some rake tasks

  Scenario: Running rake --tasks in a shoe project without Cucumber features
    Given I have created a directory called "my_project"
    And I have run shoe inside "my_project"
    When I run rake --tasks inside "my_project"
    Then I should not see "rake cucumber" on standard out
