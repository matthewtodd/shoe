module Shoe
  module Tasks

    class Abstract
      attr_reader :spec

      def initialize(spec)
        @spec = if spec.respond_to?(:rubygems_version)
                  spec
                else
                  Gem::Specification.load(spec)
                end

        @spec.extend(LocalGemspecExtensions)

        if active?
          define
        end
      end

      def active?
        true
      end

      private

      module LocalGemspecExtensions #:nodoc:
        def full_gem_path
          Dir.pwd
        end
      end

      def before(name, dependency)
        desc Rake::Task[dependency].comment
        task name => dependency
      end

      def before_existing(name, dependency)
        if Rake::Task.task_defined?(name)
          task name => dependency
        end
      end

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
