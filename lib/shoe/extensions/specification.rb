module Shoe
  module Extensions

    module Specification
      def full_gem_path
        Dir.pwd
      end

      def has_version_greater_than?(string)
        version > Gem::Version.new(string)
      end
    end

  end
end
