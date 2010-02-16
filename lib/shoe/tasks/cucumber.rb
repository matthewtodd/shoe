module Shoe
  module Tasks

    class Cucumber < AbstractTask
      def active?
        File.directory?('features')
      end

      def define
        begin
          require 'cucumber/rake/task'
        rescue LoadError
          # no cuke for you
        else
          define_tasks
        end
      end

      def update_spec
        spec.files += Rake::FileList['features/**/*']
      end

      private

      def define_tasks
        namespace :cucumber do
          ::Cucumber::Rake::Task.new(:ok, 'Run features') do |task|
            task.cucumber_opts = '--tags ~@wip'
          end

          ::Cucumber::Rake::Task.new(:wip, 'Run work-in-progress features') do |task|
            task.cucumber_opts = '--tags @wip --wip'
          end
        end

        before(:default, 'cucumber:ok')
        before(:default, 'cucumber:wip')
      end
    end

  end
end
