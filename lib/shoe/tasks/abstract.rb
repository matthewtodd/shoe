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

      def define
        # no-op
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
        message = StringIO.new
        width   = 72

        message.puts '-' * width
        message.puts "#{subject} warning from shoe".upcase
        paragraphs.each do |paragraph|
          message.puts
          message.puts wrap(paragraph, width)
        end
        message.puts '-' * width

        $stderr.write yellow(message.string)
        $stderr.flush
      end

      # blatantly stolen from Gem::Command
      def wrap(text, width)
        text.gsub(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
      end

      def yellow(string)
        if $stderr.tty?
          "\e[33m#{string}\e[0m"
        else
          string
        end
      end
    end

  end
end
