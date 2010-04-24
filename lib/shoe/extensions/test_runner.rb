module Shoe
  module Extensions

    # Conforms the normal TestRunner interface to the slightly different form
    # called by Gem::Validator.
    module TestRunner
      def run(*args)
        new(args.first, Test::Unit::UI::NORMAL).start
      end
    end

  end
end
