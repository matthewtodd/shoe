require 'yaml'

module ProjectFiles
  def add_files_for_c_extension
    add_to_gemspec 's.extensions = `git ls-files -- "ext/**/extconf.rb"`.split("\n")'

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

    system 'git add .'
  end

  def add_files_for_cucumber(assertion='')
    write_file 'cucumber.yml', { 'default' => 'features', 'wip' => 'features' }.to_yaml

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

  def add_files_for_ronn
    write_file 'man/foo.3.ronn', <<-END.gsub(/^ */, '')
      foo(3) -- be awesome
      ====================
    END

    system 'git add .'
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

    system 'git add .'
  end
end

Shoe::TestCase.send(:include, ProjectFiles)
