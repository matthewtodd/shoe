module Shoe
  module Extensions

    module TestRunner
      # Conforms the normal TestRunner interface to the slightly different form
      # called by Gem::Validator.
      #
      # Note that we use Test::Unit::AutoRunner (rather than going directly for
      # Test::Unit::UI::Console::TestRunner) in order to give redgreen a chance
      # to register itself, should it have been required in one of the
      # test_files.
      def self.run(suite, ui)
        runner = Test::Unit::AutoRunner.new(false)
        runner.collector = lambda { suite }
        runner.run.extend(BooleanPassed)
      end

      private

      module BooleanPassed #:nodoc:
        def passed?
          self
        end
      end
    end

  end
end
