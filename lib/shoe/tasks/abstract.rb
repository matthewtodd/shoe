module Shoe
  module Tasks

    class Abstract
      attr_reader :spec

      def initialize(spec)
        @spec = spec
        define if active?
      end

      def active?
        true
      end

      private

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
        WarningMessage.new(subject, paragraphs).write($stderr)
      end

      class WarningMessage
        def initialize(subject, paragraphs)
          @subject    = subject
          @paragraphs = paragraphs
          @width      = 72
        end

        def write(stream)
          stream.write("\e[33m") if stream.tty?
          stream.write(self)
          stream.write("\e[0m") if stream.tty?
          stream.flush
        end

        def to_s
          buffer = StringIO.new

          buffer.puts '-' * @width
          buffer.puts "#{@subject} warning from shoe".upcase

          @paragraphs.each do |paragraph|
            buffer.puts
            buffer.puts wrap(paragraph, @width)
          end

          buffer.puts '-' * @width
          buffer.string
        end

        private

        # blatantly stolen from Gem::Command
        def wrap(text, width)
          text.gsub(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
        end
      end
    end

  end
end
