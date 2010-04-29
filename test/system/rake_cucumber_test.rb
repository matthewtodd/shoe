require 'test/helper'
require 'yaml'

class RakeCucumberTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

  def setup
    super
    in_project 'foo'
    system 'shoe'
  end

  test 'rake cucumber is active only if there are profiles in cucumber.yml', :require => 'cucumber' do
    assert_no_task 'cucumber'
    add_files_for_cucumber
    assert_task 'cucumber'
    assert_task 'cucumber:wip'
  end

  test 'rake cucumber runs cucumber features', :require => 'cucumber' do
    add_files_for_cucumber
    system 'rake cucumber'
    assert_match '1 scenario (1 passed)', stdout
  end

  test 'rake cucumber depends on rake compile', :require => 'cucumber' do
    add_files_for_c_extension
    add_files_for_cucumber 'require "foo/extension"'
    system 'rake cucumber'
    assert_match '1 scenario (1 passed)', stdout
  end

  private

  def add_files_for_cucumber(assertion='')
    write_file 'cucumber.yml', { 'default' => 'features', 'wip' => 'features' }.to_yaml

    write_file 'features/api.feature', <<-END.gsub(/^      /, '')
      Feature: The API
        Scenario: Exercising something
          Then I should pass
    END

    write_file 'features/step_definitions/steps.rb', <<-END
      Then /^I should pass$/ do
        #{assertion}
      end
    END
  end
end
