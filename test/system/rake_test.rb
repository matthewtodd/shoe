require 'test/helper'

class RakeTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

  def setup
    super
    in_project 'foo'
    system 'shoe --no-test-unit'
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

end
