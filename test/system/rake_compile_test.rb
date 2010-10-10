require 'test/helper'

class RakeCompileTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

  def setup
    super
    system 'bundle gem foo'
    in_project 'foo'
    configure_project_for_shoe
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
end
