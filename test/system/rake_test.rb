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

  test 'rake compile is active only if there are extensions' do
    in_git_project 'foo'
    system 'shoe'

    system 'rake --tasks'
    assert_no_match /rake compile/, stdout

    add_files_for_c_extension('foo')

    system 'rake --tasks'
    assert_match /rake compile/, stdout
  end

  test 'rake compile builds extensions' do
    in_git_project 'foo'
    system 'shoe'
    add_files_for_c_extension('foo')

    system 'rake compile'
    system 'ruby -Ilib -rfoo/extension -e "puts Foo::Extension.name"'
    assert_equal 'Foo::Extension', stdout.chomp
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

end
