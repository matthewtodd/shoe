require 'test/helper'

class RakeTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

  def setup
    super
    in_project 'foo'
    system 'shoe --no-test-unit'
  end

  test 'rake release is enabled once the version is greater than 0' do
    perform_initial_commit
    assert_no_task 'release'
    bump_version_to '0.1.0'
    assert_task 'release'
  end

  test 'rake release is disabled if the version has already been tagged' do
    perform_initial_commit
    bump_version_to '0.1.0'
    system 'git tag v0.1.0'
    assert_no_task 'release'
  end

  test 'rake release is disabled if current branch is not master' do
    perform_initial_commit
    bump_version_to '0.1.0'
    system 'git checkout -b other'
    assert_no_task 'release'
  end

  test 'rake release tags, builds, and pushes' do
    perform_initial_commit
    add_git_remote 'origin'
    bump_version_to '0.1.0'

    uploaded_gem = with_fake_rubygems_server do
      system 'rake release'
    end

    # local should have tag
    system 'git tag'
    assert_match 'v0.1.0', stdout

    # origin should have refs and tags
    system "git ls-remote --heads --tags . master"
    local = stdout
    system "git ls-remote --heads --tags origin master"
    assert_match local, stdout

    # gem should be pushed
    assert_equal File.read('foo-0.1.0.gem'), uploaded_gem
  end

  test 'rake release depends on rake ronn', :require => 'ronn' do
    perform_initial_commit
    bump_version_to '0.1.0'

    uploaded_gem = with_fake_rubygems_server do
      system 'rake release'
    end

    assert uploaded_gem.contents.include?('man/foo.3'),
           uploaded_gem.contents.inspect
  end

  test 'rake ronn is enabled if there are ronn files', :require => 'ronn' do
    assert_task 'ronn'
    system 'rm **/*.ronn'
    assert_no_task 'ronn'
  end

  test 'rake ronn generates man pages', :require => 'ronn' do
    ENV['MANPAGER'] = '/bin/cat'
    system 'rake ronn'
    assert_file 'man/foo.3'
    assert_match 'FOO(3)', stdout.chomp
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

  def add_git_remote(name)
    path = File.expand_path("../#{name}.git")
    system "git init --bare #{path}"
    system "git remote add #{name} #{path}"
  end

  def bump_version_to(version)
    write_file 'lib/foo.rb', <<-END
      module Foo
        VERSION = '#{version}'
      end
    END
  end

  def perform_initial_commit
    system 'git init'
    system 'git add .'
    system 'git commit -a -m "Initial commit."'
  end

end
