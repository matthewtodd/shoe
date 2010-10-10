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

      # TODO can this method be removed once I've cleaned up the tests?
      def append_file(path, contents)
        inject_into_file(path, contents, :after => /\z/)
      end

      # TODO can this method be removed once I've cleaned up the tests?
      def prepend_file(path, contents)
        inject_into_file(path, contents, :before => /\A/)
      end

      # Stolen from thor, then simplified a bit.
      def inject_into_file(path, contents, options={})
        flag = nil

        if options.key?(:after)
          contents = '\0' + contents + "\n"
          flag     = options.delete(:after)
        else
          contents = contents + "\n" + '\0'
          flag     = options.delete(:before)
        end

        write_file(path, File.read(path).gsub(flag, contents))
      end

      # TODO can this method be removed once I've cleaned up the tests?
      def prepend_shoe_path_to_gemfile
        prepend_file('Gemfile', "path '#{SHOE_PATH}'")
      end

      def in_project(name)
        Dir.mkdir(name) unless File.directory?(name)
        Dir.chdir(name)
      end

      def configure_project_for_shoe
        prepend_file 'Gemfile',  "path '#{SHOE_PATH}'"
        add_development_dependency 'shoe'
        append_file  'Rakefile', "require 'shoe'"
        append_file  'Rakefile', "Shoe.install_tasks"
      end

      def add_to_gemspec(contents)
        gemspec = Dir['*.gemspec'].first
        inject_into_file(gemspec, contents, :before => /en.\s*\z/)
      end

      def add_development_dependency(name)
        add_to_gemspec("s.add_development_dependency('#{name}')")
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

    end

  end
end
