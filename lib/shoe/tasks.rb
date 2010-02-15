module Shoe
  module Tasks

    module Registration
      def register(task)
        tasks.push(task)
      end

      def each(&block)
        tasks.each(&block)
      end

      private

      def tasks
        @tasks ||= []
      end
    end

    extend Registration

    class AbstractTask < Struct.new(:spec)
      def self.inherited(subclass)
        Shoe::Tasks.register(subclass)
      end

      def self.define(spec)
        task = new(spec)

        if task.active?
          task.update_spec
          task.define
        end

        task
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
    end

  end
end

require 'shoe/tasks/bin'
require 'shoe/tasks/clean'
require 'shoe/tasks/gemspec'
require 'shoe/tasks/rdoc'
require 'shoe/tasks/release'
require 'shoe/tasks/resources'
require 'shoe/tasks/shell'
require 'shoe/tasks/shoulda'
require 'shoe/tasks/test'

# put cucumber toward the end so tests will run before features
require 'shoe/tasks/cucumber'

# put compile last so it can register itself as a dependency
require 'shoe/tasks/compile'
