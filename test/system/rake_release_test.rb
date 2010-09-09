require 'test/helper'

class RakeReleaseTest < Test::Unit::TestCase
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

  private

  def add_git_remote(name)
    path = File.expand_path("../#{name}.git")
    system "git init --bare #{path}"
    system "git remote add #{name} #{path}"
  end

  def bump_version_to(version)
    write_file 'lib/foo/version.rb', <<-END
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

  def with_fake_rubygems_server(&block)
    Shoe::TestExtensions::FakeRubygemsServer.start(&block)
  end
end
