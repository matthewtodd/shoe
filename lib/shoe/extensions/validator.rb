module Shoe
  module Extensions

    module Validator
      def self.extended(base)
        base.send(:include, InstanceMethods)
        base.send(:remove_const, :TestRunner)
        base.send(:const_set, :TestRunner,
          Test::Unit::UI::Console::TestRunner.extend(TestRunner))
      end

      module InstanceMethods
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
