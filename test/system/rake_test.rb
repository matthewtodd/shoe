require 'test/helper'
require 'yaml'

class RakeTest < Test::Unit::TestCase
  isolate_environment

  def setup
    super
    in_git_project 'foo'
    system 'shoe --no-test-unit'
  end

  test 'rake clean removes ignored files' do
    write_file '.gitignore', "bar\n"
    write_file 'bar', 'NOT LONG FOR THIS WORLD'
    files_before_clean = find('.')

    system 'rake clean'

    assert_match 'Removing bar', stdout
    assert_find  '.', files_before_clean - ['bar']
  end

  test 'rake compile is active only if there are extensions' do
    system 'rake --tasks'
    assert_no_match /compile/, stdout

    add_files_for_c_extension 'foo'

    system 'rake --tasks'
    assert_match /compile/, stdout
  end

  test 'rake compile builds extensions' do
    add_files_for_c_extension 'foo'

    system 'rake compile'

    system 'ruby -Ilib -rfoo/extension -e "puts Foo::Extension.name"'
    assert_equal 'Foo::Extension', stdout.chomp
  end

  test 'rake cucumber is active only if there are profiles in cucumber.yml' do
    system 'rake --tasks'
    assert_no_match /cucumber/, stdout

    write_file 'cucumber.yml', { 'default' => 'features', 'wip' => 'features' }.to_yaml

    system 'rake --tasks'
    assert_match /cucumber\s/, stdout
    assert_match /cucumber:wip/, stdout
  end

  test 'rake cucumber runs cucumber features', :require => 'cucumber' do
    add_files_for_cucumber
    system 'rake cucumber'
    assert_match '1 scenario (1 passed)', stdout
  end

  test 'rake cucumber depends (perhaps indirectly) on rake compile', :require => 'cucumber' do
    add_files_for_c_extension 'foo'
    add_files_for_cucumber 'require "foo/extension"'
    system 'rake cucumber'
    assert_match '1 scenario (1 passed)', stdout
  end

  test 'rake test is active only if there are test files present' do
    system 'rake --tasks'
    assert_no_match /test/, stdout

    write_file 'test/foo_test.rb', <<-END
      require 'test/unit'
      class FooTest < Test::Unit::TestCase
        def test_dummy
          assert true
        end
      end
    END

    system 'rake --tasks'
    assert_match /test/, stdout
  end

  private

  def add_files_for_c_extension(project_name, module_name = project_name.capitalize)
    write_file "ext/#{project_name}/extconf.rb", <<-END.gsub(/^ */, '')
      require 'mkmf'
      create_makefile '#{project_name}/extension'
    END

    write_file "ext/#{project_name}/extension.c", <<-END.gsub(/^ */, '')
      #include "ruby.h"
      static VALUE m#{module_name};
      static VALUE mExtension;
      void Init_extension() {
        m#{module_name} = rb_define_module("#{module_name}");
        mExtension = rb_define_module_under(m#{module_name}, "Extension");
      }
    END
  end

  def add_files_for_cucumber(assertion='')
    write_file 'cucumber.yml', { 'default' => 'features' }.to_yaml

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
