require 'test/helper'

class RakeCucumberTest < Shoe::TestCase
  describe 'rake cucumber' do
    requires 'cucumber' do
      it 'is active only if there are profiles in cucumber.yml' do
        add_development_dependency 'cucumber'
        assert_no_task 'cucumber'
        add_files_for_cucumber
        assert_task 'cucumber'
        assert_task 'cucumber:wip'
      end

      it 'runs cucumber features' do
        add_development_dependency 'cucumber'
        add_files_for_cucumber
        system 'rake cucumber'
        assert_match '1 scenario (1 passed)', stdout
      end

      it 'depends on rake compile' do
        add_development_dependency 'cucumber'
        add_files_for_c_extension
        add_files_for_cucumber 'require "foo/extension"'
        system 'rake cucumber'
        assert_match '1 scenario (1 passed)', stdout
      end
    end
  end
end
