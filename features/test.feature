Feature: Test
  In order to run tests
  As a developer
  I want shoe to give me a rake task

  Scenario: Running rake --tasks in a shoe project without tests
    Given I have started a project called "my_project"
    And I have run bundle exec shoe --no-test-unit inside "my_project"
    And I have run git init inside "my_project"
    When I run bundle exec rake --tasks inside "my_project"
    Then I should not see "rake test" on standard out

  Scenario: Running rake --tasks in a shoe project with tests
    Given I have started a project called "my_project"
    And I have run bundle exec shoe --no-test-unit inside "my_project"
    And I have run git init inside "my_project"
    And I have created a directory called "my_project/test"
    And I have created a file called "my_project/test/foo_test.rb" containing ""
    When I run bundle exec rake --tasks inside "my_project"
    Then I should see "rake test" on standard out
