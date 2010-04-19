module Shoe
  module Tasks

    class Abstract
      attr_reader :spec

      def initialize(spec)
        @spec = Gem::Specification.load(spec)
        @spec.extend(Extensions::Specification)
        define if active?
      end

      private

      def warn(subject, *paragraphs)
        $stderr.extend(Colored).
                extend(Formatted).
                message(subject, paragraphs)
      end

      module Colored #:nodoc:
        YELLOW = "\e[33m"
        CLEAR  = "\e[0m"

        def write(string)
          super(YELLOW) if tty?
          super
          super(CLEAR) if tty?
        end
      end

      module Formatted #:nodoc:
        WIDTH = 72
        WRAP  = /(.{1,#{WIDTH}})( +|$\n?)|(.{1,#{WIDTH}})/

        def message(subject, paragraphs)
          border
          heading(subject)
          body(paragraphs)
          border
        end

        private

        def border
          puts '-' * WIDTH
        end

        def heading(string)
          puts "#{string} warning from shoe".upcase
        end

        def body(paragraphs)
          paragraphs.each do |paragraph|
            puts
            puts wrap(paragraph)
          end
        end

        def wrap(string)
          string.gsub(WRAP, "\\1\\3\n")
        end
      end
    end

  end
end
