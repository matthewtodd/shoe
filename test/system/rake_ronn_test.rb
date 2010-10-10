require 'test/helper'

class RakeRonnTest < Shoe::TestCase
  def setup
    super
    system 'bundle gem foo'
    in_project 'foo'
    configure_project_for_shoe
  end

  test 'rake ronn is enabled if there are ronn files', :require => 'ronn' do
    add_development_dependency 'ronn'
    assert_no_task 'ronn'
    add_files_for_ronn
    assert_task 'ronn'
  end

  test 'rake ronn generates man pages', :require => 'ronn' do
    ENV['MANPAGER'] = '/bin/cat'
    add_development_dependency 'ronn'
    add_files_for_ronn
    system 'rake ronn'
    assert_file 'man/foo.3'
    assert_match 'FOO(3)', stdout.chomp
  end

  test 'rake ronn registers itself as a prerequisite of rake build', :require => 'ronn' do
    add_development_dependency 'ronn'
    add_files_for_ronn
    mask_todos_in_gemspec
    system 'rake build --trace'
    assert_file 'man/foo.3'
  end

  private

  def add_files_for_ronn
    write_file 'man/foo.3.ronn', <<-END.gsub(/^ */, '')
      foo(3) -- be awesome
      ====================
    END

    system 'git add .'
  end
end
