module Shoe
  module Tasks

    class << self
      include Enumerable

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

    class AbstractTask < Struct.new(:spec)
      def self.inherited(subclass)
        Shoe::Tasks.register(subclass)
      end

      def define
        if should_define_tasks?
          define_tasks
        end
      end

      private

      def should_define_tasks?
        true
      end

      def define_tasks
        raise "Please implement define_tasks in your subclass."
      end
    end

  end
end

require 'shoe/tasks/clean'
