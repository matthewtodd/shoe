module Shoe
  module Tasks

    autoload :Bin,       'shoe/tasks/bin'
    autoload :Clean,     'shoe/tasks/clean'
    autoload :Compile,   'shoe/tasks/compile'
    autoload :Cucumber,  'shoe/tasks/cucumber'
    autoload :Gemspec,   'shoe/tasks/gemspec'
    autoload :Rdoc,      'shoe/tasks/rdoc'
    autoload :Release,   'shoe/tasks/release'
    autoload :Resources, 'shoe/tasks/resources'
    autoload :Shell,     'shoe/tasks/shell'
    autoload :Shoulda,   'shoe/tasks/shoulda'
    autoload :Test,      'shoe/tasks/test'

    LOAD_ORDER = %w(
      Bin
      Clean
      Gemspec
      Rdoc
      Release
      Resources
      Shell
      Shoulda
      Test
      Cucumber
      Compile
    )

    def self.each
      LOAD_ORDER.map { |name| const_get name }.
                each { |task| yield task }
    end

    class AbstractTask
      def self.define(spec)
        task = new(spec)

        if task.active?
          task.update_spec
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

      def update_spec
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
