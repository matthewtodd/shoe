require 'tempfile'

module Shoe
  module TestExtensions

    module IsolatedEnvironment
      def setup
        @environment = Environment.new
        @environment.setup do |env|
          env.path('PATH')    { |path| path.unshift Pathname.new('bin').expand_path }
          env.path('RUBYLIB') { |path| path.unshift Pathname.new('lib').expand_path }
        end
        super
      end

      def teardown
        super
        @environment.teardown
      end

      private

      class Environment
        def setup
          @initial_environment = {}
          ENV.each { |name, value| @initial_environment[name] = value }
          yield self
          @initial_directory   = Dir.pwd
          @working_directory   = Dir.mktmpdir
          Dir.chdir(@working_directory)
        end

        def path(name)
          path = ENV[name].to_s.split(File::PATH_SEPARATOR)
          yield path
          ENV[name] = path.join(File::PATH_SEPARATOR)
        end

        def teardown
          Dir.chdir(@initial_directory)
          FileUtils.remove_entry_secure(@working_directory)
          ENV.clear
          @initial_environment.each { |name, value| ENV[name] = value }
        end
      end
    end

  end
end

