Feature: Getting started
  In order to start using shoe
  As a developer
  I want a little help generating my Rakefile

  Scenario: Running shoe to create a new project
    When I run shoe my_project inside "."
    Then I should see a file "my_project/.gitignore"
    And I should see a file "my_project/Rakefile"
    And I should see a file "my_project/README.rdoc"
    And I should see a file "my_project/lib/my_project.rb"
    And I should see a file "my_project/test/helper.rb"
    And I should see a file "my_project/test/my_project_test.rb"
    And I should see a file "my_project/my_project.gemspec"

  Scenario: Running shoe --application to create a new project
    When I run shoe --application my_project inside "."
    Then I should see a file "my_project/bin/my_project"
    And I should see a file "my_project/lib/my_project/application.rb"

  Scenario: Running shoe --extension to create a new project
    When I run shoe --extension my_project inside "."
    Then I should see a file "my_project/ext/my_project/extconf.rb"
    And I should see a file "my_project/ext/my_project/extension.c"

  Scenario: Running shoe with no arguments in an existing project that already has a Rakefile
    Given I have created a directory called "my_project"
    And I have created a file called "my_project/Rakefile" containing "# RAKEFILE CONTENTS"
    When I run shoe inside "my_project"
    Then I should see "WARN: not clobbering existing Rakefile" on standard error
    And the contents of "my_project/Rakefile" should still be "# RAKEFILE CONTENTS"

