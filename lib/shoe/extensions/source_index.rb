module Shoe
  module Extensions

    module SourceIndex
      attr_accessor :local_gemspec

      def find_name(*args)
        if args.first == local_gemspec.name
          [local_gemspec]
        else
          super
        end
      end
    end

  end
end
