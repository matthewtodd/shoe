
module Shoe
  module Extensions

    module Validator
      def self.extended(base)
        if RUBY_VERSION < '1.9'
          require 'test/unit'
          Test::Unit.run = true
          base.send :include, Ruby18::InstanceMethods
          base.send :remove_const, :TestRunner
          base.send :const_set,    :TestRunner, Ruby18::TestRunner
        else
          require 'minitest/unit'
          MiniTest::Unit.class_eval('@@installed_at_exit = true')
        end
      end

      module Ruby18 #:nodoc:
        module InstanceMethods #:nodoc:
          def alert_error(*args)
            # no-op
          end

          def unit_test(*args)
            exit(1) unless super.passed?
          end
        end

        module TestRunner #:nodoc:
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

  end
end
