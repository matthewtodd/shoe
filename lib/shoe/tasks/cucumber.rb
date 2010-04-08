require 'yaml'

module Shoe
  module Tasks

    class Cucumber < Abstract
      def active?
        File.exist?('cucumber.yml')
      end

      def define
        begin
          require 'cucumber/rake/task'
        rescue LoadError
          warn 'cucumber',
            "Although you have a cucumber.yml, it seems you don't have cucumber installed.",
            "You probably want to add a \"gem 'cucumber'\" to your Gemfile."
        else
          define_tasks
        end
      end

      private

      def define_tasks
        cucumber_profiles.each do |profile|
          if profile == 'default'
            define_default_task
          else
            define_profile_task(profile)
          end
        end
      end

      def cucumber_profiles
        config = YAML.load_file('cucumber.yml')
        config.respond_to?(:keys) ? config.keys : []
      end

      def define_default_task
        ::Cucumber::Rake::Task.new(:cucumber, 'Run features') do |task|
          task.profile = 'default'
        end

        before(:default, 'cucumber')
      end

      def define_profile_task(profile)
        namespace :cucumber do
          ::Cucumber::Rake::Task.new(profile, "Run #{profile} features") do |task|
            task.profile = profile
          end
        end
      end
    end

  end
end
