module Shoe
  module Tasks

    autoload :Clean,     'shoe/tasks/clean'
    autoload :Compile,   'shoe/tasks/compile'
    autoload :Cucumber,  'shoe/tasks/cucumber'
    autoload :Rdoc,      'shoe/tasks/rdoc'
    autoload :Release,   'shoe/tasks/release'
    autoload :Test,      'shoe/tasks/test'

    LOAD_ORDER = %w(
      Clean
      Rdoc
      Release
      Test
      Cucumber
      Compile
    )

    def self.define(spec_path)
      spec = Gem::Specification.load(spec_path)
      each do |task|
        task.define spec
      end
    end

    def self.each
      LOAD_ORDER.map { |name| const_get name }.
                each { |task| yield task }
    end

    class AbstractTask
      def self.define(spec)
        task = new(spec)

        if task.active?
          task.define
        end

        task
      end

      attr_reader :spec

      def initialize(spec)
        @spec = spec
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
