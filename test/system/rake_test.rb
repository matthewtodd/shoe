require 'test/helper'
require 'yaml'

class RakeTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

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
    assert_find  '.', files_before_clean - ['bar']
  end

  test 'rake compile is active only if there are extensions' do
    assert_no_task 'compile'
    add_files_for_c_extension
    assert_task 'compile'
  end

  test 'rake compile builds extensions' do
    add_files_for_c_extension
    system 'rake compile'
    system 'ruby -Ilib -rfoo/extension -e "puts Foo::Extension.name"'
    assert_equal 'Foo::Extension', stdout.chomp
  end

  test 'rake cucumber is active only if there are profiles in cucumber.yml', :require => 'cucumber' do
    assert_no_task 'cucumber'
    write_file 'cucumber.yml', { 'default' => 'features', 'wip' => 'features' }.to_yaml
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

  test 'rake rdoc is unconditionally active' do
    assert_task 'rdoc'
  end

  pending 'rake rdoc generates rdoc' do
    # need to move out Launchy or stub BROWSER or something
    # I might prefer using hub's approach, just so I don't depend on Launchy.
  end

  test 'rake release is enabled once the version is greater than 0' do
    assert_no_task 'release'
    bump_version_to '0.1.0'
    assert_task 'release'
  end

  test 'rake release is disabled if the version has already been tagged' do
    bump_version_to '0.1.0'
    system 'git add .'
    system 'git commit -m "dummy message"'
    system 'git tag v0.1.0'
    assert_no_task 'release'
  end

  test 'rake release is disabled if current branch is not master' do
    bump_version_to '0.1.0'
    system 'git add .'
    system 'git commit -m "dummy message"'
    system 'git checkout -b other'
    assert_no_task 'release'
  end

  pending 'rake release does a lot of things' do
    # I can fake everything else if origin is also on the filesystem; but what
    # am I going to do about `gem push`?
  end

  pending 'rake release depends on rake ronn', :require => 'ronn'

  test 'rake ronn is enabled if there are ronn files' do
    assert_no_task 'ronn'
    write_file 'man/foo.1.ronn', ''
    assert_task 'ronn'
  end

  pending 'rake ronn generates man pages', :require => 'ronn' do
    # This task will then launch man; so I need to set the MANPAGER?
  end

  test 'rake test is active only if there are test files present' do
    assert_no_task 'test'
    add_files_for_test
    assert_task 'test'
  end

  test 'rake test runs tests' do
    add_files_for_test
    system 'rake test'
    assert_match '1 tests, 1 assertions, 0 failures, 0 errors', stdout
  end

  test 'rake test depends (perhaps indirectly) on rake compile' do
    add_files_for_c_extension
    add_files_for_test 'require "foo/extension"'
    system 'rake test'
    assert_match '1 tests, 0 assertions, 0 failures, 0 errors', stdout
  end

  private

  def assert_no_task(name)
    system 'rake --tasks'
    assert_no_match /\srake #{name}\s/, stdout
  end

  def assert_task(name)
    system 'rake --tasks'
    assert_match /\srake #{name}\s/, stdout
  end

  def add_files_for_c_extension
    write_file "ext/foo/extconf.rb", <<-END.gsub(/^ */, '')
      require 'mkmf'
      create_makefile 'foo/extension'
    END

    write_file "ext/foo/extension.c", <<-END.gsub(/^ */, '')
      #include "ruby.h"
      static VALUE mFoo;
      static VALUE mExtension;
      void Init_extension() {
        mFoo = rb_define_module("Foo");
        mExtension = rb_define_module_under(mFoo, "Extension");
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

  def add_files_for_test(assertion='assert true')
    write_file 'test/foo_test.rb', <<-END
      require 'test/unit'
      class FooTest < Test::Unit::TestCase
        def test_something
          #{assertion}
        end
      end
    END
  end

  def bump_version_to(version)
    write_file 'lib/foo.rb', <<-END
      module Foo
        VERSION = '#{version}'
      end
    END
  end
end
