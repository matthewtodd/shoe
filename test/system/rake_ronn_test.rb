require 'test/helper'

class RakeRonnTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

  def setup
    super
    in_project 'foo'
    system 'shoe'
    prepend_shoe_path_to_gemfile
  end

  test 'rake ronn is enabled if there are ronn files', :require => 'ronn' do
    append_file 'Gemfile', 'gem "ronn"'
    assert_task 'ronn'
    system 'rm **/*.ronn'
    assert_no_task 'ronn'
  end

  test 'rake ronn generates man pages', :require => 'ronn' do
    ENV['MANPAGER'] = '/bin/cat'
    append_file 'Gemfile', 'gem "ronn"'
    system 'rake ronn'
    assert_file 'man/foo.3'
    assert_match 'FOO(3)', stdout.chomp
  end

  test 'rake ronn registers itself as a prerequisite of rake build', :require => 'ronn' do
    append_file 'Gemfile', 'gem "ronn"'
    system 'rake build'
    assert_file 'man/foo.3'
  end
end
