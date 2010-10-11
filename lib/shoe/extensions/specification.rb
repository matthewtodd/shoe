module Shoe
  module Extensions

    module Specification
      def self.extended(specification)
        specification.loaded_from = Dir.pwd
      end

      def full_gem_path
        Dir.pwd
      end
    end

  end
end
