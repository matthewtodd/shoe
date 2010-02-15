module Shoe
  module Tasks

    class << self
      def tasks
        @tasks ||= []
      end

      def register(task)
        tasks.push(task)
      end

      def each(&block)
        tasks.each(&block)
      end
    end

    class AbstractTask
      def self.inherited(subclass)
        Shoe::Tasks.register(subclass)
      end

      def self.define(spec)
        task = new(spec)
        task.define if task.should_define?
        task
      end

      attr_reader :spec

      def initialize(spec)
        @spec = spec
        update_spec
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

      def define
        # no-op
      end

      def should_define?
        true
      end

      def update_spec
        # no-op
      end
    end

  end
end

require 'shoe/tasks/bin'
require 'shoe/tasks/clean'
require 'shoe/tasks/gemspec'
require 'shoe/tasks/rdoc'
require 'shoe/tasks/release'
require 'shoe/tasks/shell'
require 'shoe/tasks/shoulda'
require 'shoe/tasks/test'

# put cucumber toward the end so tests will run before features
require 'shoe/tasks/cucumber'

# put compile last so it can register itself as a dependency
require 'shoe/tasks/compile'
