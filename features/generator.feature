Feature: Getting started
  In order to start using shoe
  As a developer
  I want a little help generating my Rakefile

  Background:
    Given I have created a directory called "my_project"
    And I have created a file called "my_project/Gemfile" containing:
      """
      source :rubygems
      gem 'shoe', :group => :development
      """

  Scenario: Running shoe with no arguments in an empty directory
    When I run bundle exec shoe inside "my_project"
    Then I should see a file "my_project/.gitignore"
    And I should see a file "my_project/Rakefile"
    And I should see a file "my_project/README.rdoc"
    And I should see a file "my_project/lib/my_project.rb"
    And I should see a file "my_project/test/helper.rb"
    And I should see a file "my_project/test/my_project_test.rb"
    And I should see a file "my_project/my_project.gemspec"

  Scenario: Running shoe --application in an empty directory
    When I run bundle exec shoe --application inside "my_project"
    Then I should see a file "my_project/bin/my_project"
    And I should see a file "my_project/lib/my_project/application.rb"

  Scenario: Running shoe --extension in an empty directory
    When I run bundle exec shoe --extension inside "my_project"
    Then I should see a file "my_project/ext/my_project/extconf.rb"
    And I should see a file "my_project/ext/my_project/extension.c"

  Scenario: Running shoe with no arguments in a directory that already has a Rakefile
    Given I have created a file called "my_project/Rakefile" containing "# RAKEFILE CONTENTS"
    When I run bundle exec shoe inside "my_project"
    Then I should see "Rakefile exists. Not clobbering." on standard error
    And the contents of "my_project/Rakefile" should still be "# RAKEFILE CONTENTS"
