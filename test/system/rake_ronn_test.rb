require 'test/helper'

class RakeRonnTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

  def setup
    super
    in_project 'foo'
    system 'shoe'
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

  pending 'rake ronn registers itself as a prerequisite of rake build', :require => 'ronn' do
    system 'rake build'
    assert_file 'man/foo.3'
  end
end
