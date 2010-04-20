Feature: Cucumber
  In order to use cucumber conveniently
  As a developer
  I want shoe to give me a rake task

  Scenario: Running rake --tasks in a shoe project without Cucumber features
    Given I have run shoe my_project inside "."
    When I run rake --tasks inside "my_project"
    Then I should not see "rake cucumber" on standard out

  Scenario: Running rake --tasks in a shoe project with Cucumber features
    Given I have run shoe my_project inside "."
    And I have run git init inside "."
    And I have created a file called "my_project/cucumber.yml" containing:
      """
      default: --tags ~@wip
      wip: --tags @wip --wip
      """
    When I run rake --tasks inside "my_project"
    Then I should see "rake cucumber" on standard out
    And I should see "rake cucumber:wip" on standard out

  Scenario: Running rake --tasks in a shoe project with a bad cucumber.yml
    Given I have run shoe my_project inside "."
    And I have created a file called "my_project/cucumber.yml" containing ""
    When I run rake --tasks inside "my_project"
    Then I should not see "rake cucumber" on standard out
