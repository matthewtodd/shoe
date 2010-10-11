require 'yaml'

module ProjectFiles
  def add_files_for_c_extension
    add_to_gemspec(
      's.extensions = `git ls-files -- "ext/**/extconf.rb"`.split("\n")')

    write_versioned_file "ext/foo/extconf.rb", <<-END
      require 'mkmf'
      create_makefile 'foo/extension'
    END

    write_versioned_file "ext/foo/extension.c", <<-END
      #include "ruby.h"
      static VALUE mFoo;
      static VALUE mExtension;
      void Init_extension() {
        mFoo = rb_define_module("Foo");
        mExtension = rb_define_module_under(mFoo, "Extension");
      }
    END
  end

  def add_files_for_cucumber(assertion='')
    write_versioned_file 'cucumber.yml',
      { 'default' => 'features', 'wip' => 'features' }.to_yaml

    write_versioned_file 'features/api.feature', <<-END
      Feature: The API
        Scenario: Exercising something
          Then I should pass
    END

    write_versioned_file 'features/step_definitions/steps.rb', <<-END
      Then /^I should pass$/ do
        #{assertion}
      end
    END
  end

  def add_files_for_ronn
    write_versioned_file 'man/foo.3.ronn', <<-END
      foo(3) -- be awesome
      ====================
    END
  end

  def add_files_for_test(assertion='assert true')
    write_versioned_file 'test/foo_test.rb', <<-END
      require 'test/unit'
      class FooTest < Test::Unit::TestCase
        def test_something
          #{assertion}
        end
      end
    END
  end
end

Shoe::TestCase.send(:include, ProjectFiles)
