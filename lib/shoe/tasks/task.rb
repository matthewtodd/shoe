module Shoe
  module Tasks

    class Task
      attr_reader :spec

      def initialize(spec)
        @spec = Gem::Specification.load(spec)
        @spec.extend(Extensions::Specification)
        define if active?
      end
    end

  end
end
