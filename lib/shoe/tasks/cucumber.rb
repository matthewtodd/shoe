require 'yaml'

module Shoe
  module Tasks

    # Defines <tt>`rake cucumber`</tt> and <tt>`rake cucumber:<PROFILE>`</tt> to
    # run your Cucumber[http://cukes.info] features.
    #
    # <tt>`rake cucumber`</tt> will run features according to the <tt>default</tt> profile; <tt>`rake cucumber:foo`</tt> according to the <tt>foo</tt> profile.
    #
    # To enable and configure, create and edit your
    # <tt>{cucumber.yml}[http://wiki.github.com/aslakhellesoy/cucumber/cucumberyml]</tt>.
    class Cucumber < Abstract
      def active?
        !cucumber_profiles.empty?
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
        YAML.load_file('cucumber.yml').keys rescue []
      end

      def define_default_task
        task :prepare

        ::Cucumber::Rake::Task.new({ :cucumber => :prepare }, 'Run features') do |task|
          task.profile = 'default'
        end

        task :default
        Rake.application[:default].prerequisites.push(Rake.application[:cucumber])
      end

      def define_profile_task(profile)
        task :prepare

        namespace :cucumber do
          ::Cucumber::Rake::Task.new({ profile => :prepare }, "Run #{profile} features") do |task|
            task.profile = profile
          end
        end
      end
    end

  end
end
