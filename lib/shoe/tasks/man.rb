module Shoe
  module Tasks

    class Man < Abstract
      def active?
        !ronn_files.empty?
      end

      def define
        begin
          require 'ronn'
        rescue LoadError
          Shoe.logger.warn ['ronn',
            "Although you have .ronn files in your project, it seems you don't have ronn installed.",
            "You probably want to add a \"gem 'ronn'\" to your Gemfile and a spec.add_development_dependency('ronn') to your gemspec."]
        else
          define_tasks
        end
      end

      private

      def define_tasks
        desc 'Generate man pages'
        task :man => 'man:build' do
          sh 'man', *man_files
        end

        namespace :man do
          task :build => man_files
        end

        rule /\.\d$/ => '%p.ronn' do |task|
          ronn('--roff', task.source)
        end

        namespace :prepare do
          task :release => 'man:build'
        end
      end

      def ronn(format, file)
        sh "ronn --build #{format} --manual='RubyGems Manual' --organization='#{spec.author}' #{file}"
      end

      def ronn_files
        spec.files.grep /^man\/.*\.ronn$/
      end

      def man_files
        ronn_files.map { |path| path.sub(/\.ronn$/, '') }
      end
    end

  end
end
