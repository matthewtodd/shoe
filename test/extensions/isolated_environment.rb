require 'tempfile'

module Shoe
  module TestExtensions

    module IsolatedEnvironment
      def setup
        @environment = Environment.new
        @environment.setup
        super
      end

      def teardown
        super
        @environment.teardown
      end

      private

      class Environment
        def setup
          @initial_directory   = Dir.pwd
          @working_directory   = Dir.mktmpdir
          Dir.chdir(@working_directory)
        end

        def teardown
          Dir.chdir(@initial_directory)
          FileUtils.remove_entry_secure(@working_directory)
        end
      end
    end

  end
end

