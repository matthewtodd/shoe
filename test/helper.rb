require 'find'
require 'open3'
require 'shoe'
require 'tempfile'
require 'test/unit'

begin
  require 'redgreen' if $stdout.tty?
rescue LoadError
  # Since we don't have hard gem dependencies for testing, folks can run `gem
  # check --test shoe` without installing anything else.
end

module Shoe
  module Extensions
    module TestCase
      def isolate_environment
        include IsolatedEnvironment
        include IsolatedSystem
      end

      def test(name, &block)
        define_method("test #{name}", &block)
      end

      private

      module IsolatedEnvironment
        attr_accessor :initial_directory
        attr_accessor :working_directory

        def setup
          isolate_environment_variables
          isolate_working_directory
          super
        end

        def teardown
          super
          restore_working_directory
          restore_environment_variables
        end

        private

        def isolate_environment_variables
          munge_path { |path| path.unshift ::Pathname.new('bin').expand_path }
        end

        def restore_environment_variables
          munge_path { |path| path.shift }
        end

        def munge_path
          path = ENV['PATH'].split(File::PATH_SEPARATOR)
          yield path
          ENV['PATH'] = path.join(File::PATH_SEPARATOR)
        end

        def isolate_working_directory
          self.initial_directory = Dir.pwd
          self.working_directory = Dir.mktmpdir
          Dir.chdir(working_directory)
        end

        def restore_working_directory
          Dir.chdir(initial_directory)
          FileUtils.remove_entry_secure(working_directory)
        end
      end

      module IsolatedSystem
        attr_reader :stdout, :stderr

        def system(*args)
          stdin, stdout, stderr = Open3.popen3(*args)
          stdin.close
          @stdout = stdout.readlines
          @stderr = stderr.readlines
        end

        def find(string)
          root = ::Pathname.new(string)
          root.enum_for(:find).
                 select { |path| path.file? }.
                collect { |path| path.relative_path_from(root).to_s }.
                   sort
        end
      end
    end

    ::Test::Unit::TestCase.extend(TestCase)
  end
end
