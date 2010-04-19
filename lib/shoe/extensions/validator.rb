module Shoe
  module Extensions

    module Validator
      def alert_error(*args)
        # no-op
      end

      def unit_test(*args)
        exit(1) unless super.passed?
      end
    end

  end
end
