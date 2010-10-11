require 'test/unit'

Test::Unit.run = true

module Shoe
  module Extensions

    module Validator
      def self.extended(base)
        base.send :include, InstanceMethods
        base.test_runner = TestRunner
      end

      def test_runner=(klass)
        remove_const :TestRunner
        const_set    :TestRunner, klass
      end

      module InstanceMethods #:nodoc:
        def alert_error(*args)
          # no-op
        end

        def unit_test(*args)
          exit(1) unless super.passed?
        end
      end
    end

  end
end
