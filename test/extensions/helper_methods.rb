require 'open3'
require 'pathname'

module Shoe
  module TestExtensions

    module HelperMethods
      SHOE_PATH = File.expand_path('../../..', __FILE__)

      attr_reader :stdout

      def system(command)
        IO.popen("#{command} 2>&1") { |io| @stdout = io.read }
        assert $?.success?, @stdout
      end

      def find(string)
        root = Pathname.new(string)
        root.enum_for(:find).
               select { |path| path.file? }.
              collect { |path| path.relative_path_from(root).to_s }
      end

      def write_file(path, contents, mode='w')
        path = Pathname.new(path)
        path.parent.mkpath
        path.open(mode) { |stream| stream.write(contents) }
      end

      def append_file(path, contents)
        write_file(path, "#{contents}\n", 'a')
      end

      def prepend_file(path, contents)
        write_file(path, "#{contents}\n#{File.read(path)}")
      end

      # TODO this method should go away
      def prepend_shoe_path_to_gemfile
        prepend_file('Gemfile', "path '#{SHOE_PATH}'")
      end

      def in_project(name)
        Dir.mkdir(name) unless File.directory?(name)
        Dir.chdir(name)
      end

      def configure_project_for_shoe
        prepend_file 'Gemfile',  "path '#{SHOE_PATH}'"
        # TODO instead of appending to Gemfile, alter gemspec directly
        append_file  'Gemfile',  "gem 'shoe'"
        append_file  'Rakefile', "require 'shoe'"
        append_file  'Rakefile', "Shoe.install_tasks"
      end

      def assert_file(path)
        assert Pathname.new(path).exist?, "#{path} does not exist."
      end

      def assert_find(path, expected)
        assert_equal expected.sort, find(path).sort
      end

      def assert_no_task(name)
        system 'rake --tasks'
        assert_no_match /\srake #{name}\s/, stdout
      end

      def assert_task(name)
        system 'rake --tasks'
        assert_match /\srake #{name}\s/, stdout
      end

      def add_files_for_c_extension
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
      end

    end

  end
end
