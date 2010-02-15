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
        desc Rake.application.lookup(dependency).comment
        task name => dependency
      end

      def define
        raise "Please implement define in your subclass."
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

require 'shoe/tasks/clean'
require 'shoe/tasks/rdoc'
require 'shoe/tasks/shell'
require 'shoe/tasks/test'
require 'shoe/tasks/cucumber'
