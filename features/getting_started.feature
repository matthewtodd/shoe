Feature: Getting started
  In order to start using shoe
  As a developer
  I want a little help generating my Rakefile

  Scenario: Running shoe with no arguments in an empty directory
    Given I have created a directory called "my_project"
    When I run shoe inside "my_project"
    Then I should see a file "my_project/Rakefile"
    And I should see a file "my_project/README.rdoc"

  Scenario: Running shoe with no arguments in a directory that already has a Rakefile
    Given I have created a directory called "my_project"
    And I have created a file called "my_project/Rakefile" containing "# RAKEFILE CONTENTS"
    When I run shoe inside "my_project"
    Then I should see "Rakefile exists. Not clobbering." on standard error
    And the contents of "my_project/Rakefile" should still be "# RAKEFILE CONTENTS"
    And I should see a file "my_project/README.rdoc"

  Scenario: Running shoe with no arguments in a directory that already has a README.rdoc
    Given I have created a directory called "my_project"
    And I have created a file called "my_project/README.rdoc" containing "= README CONTENTS"
    When I run shoe inside "my_project"
    Then I should see a file "my_project/Rakefile"
    Then I should see "README.rdoc exists. Not clobbering." on standard error
    And the contents of "my_project/README.rdoc" should still be "= README CONTENTS"
