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

      def test(name, options={}, &block)
        requires = Array(options[:require])

        requires.each do |lib|
          begin
            require lib
          rescue LoadError
            warn "WARN: #{lib} is not available.\n  Skipping test \"#{name}\""
            return
          end
        end

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
          munge_path('PATH')    { |path| path.unshift ::Pathname.new('bin').expand_path }
          munge_path('RUBYLIB') { |path| path.unshift ::Pathname.new('lib').expand_path }
        end

        def restore_environment_variables
          munge_path('PATH')    { |path| path.shift }
          munge_path('RUBYLIB') { |path| path.shift }
        end

        def munge_path(name)
          path = ENV[name].to_s.split(File::PATH_SEPARATOR)
          yield path
          ENV[name] = path.join(File::PATH_SEPARATOR)
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
          @stdout = stdout.read
          @stderr = stderr.read
        end

        def find(string)
          root = ::Pathname.new(string)
          root.enum_for(:find).
                 select { |path| path.file? }.
                collect { |path| path.relative_path_from(root).to_s }
        end

        def write_file(path, contents)
          path = ::Pathname.new(path)
          path.parent.mkpath
          path.open('w') { |stream| stream.write(contents) }
        end

        def in_git_project(name)
          Dir.mkdir(name)
          Dir.chdir(name)
          system 'git init'
        end

        def assert_file(path)
          assert ::Pathname.new(path).exist?, "#{path} does not exist."
        end

        def assert_find(path, expected)
          assert_equal expected.sort, find(path).sort
        end
      end
    end

    ::Test::Unit::TestCase.extend(TestCase)
  end
end
