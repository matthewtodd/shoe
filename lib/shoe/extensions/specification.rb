module Shoe
  module Extensions

    module Specification
      def self.extended(specification)
        specification.loaded_from = Dir.pwd
      end

      def full_gem_path
        Dir.pwd
      end

      def has_version_greater_than?(string)
        version > Gem::Version.new(string)
      end
    end

  end
end
