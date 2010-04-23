require 'test/helper'

class RakeTest < Test::Unit::TestCase
  isolate_environment

  test 'rake clean removes ignored files' do
    in_git_project 'foo'
    system 'shoe'
    write_file '.gitignore', "bar\n"
    write_file 'bar', 'NOT LONG FOR THIS WORLD'

    files_before_clean = find('.')

    system 'rake clean'

    assert_match 'Removing bar', stdout
    assert_find  '.', files_before_clean - ['bar']
  end
end
