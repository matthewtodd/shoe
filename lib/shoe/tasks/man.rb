require 'launchy'

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
          Launchy::Browser.run(*html_files)
        end

        namespace :man do
          task :build => man_files.concat(html_files)
        end

        rule /\.\d$/ => '%p.ronn' do |task|
          ronn('--roff', task.source)
        end

        rule '.html' => '%X.ronn' do |task|
          ronn('--html', task.source)
        end

        task :prepare => 'man:build'
      end

      def ronn(format, file)
        sh "ronn --build #{format} --manual='RubyGems Manual' --organization='#{spec.author}' #{file}"
      end

      def ronn_files
        spec.files.grep /\.ronn$/
      end

      def man_files
        ronn_files.map { |path| path.sub(/\.ronn$/, '') }
      end

      def html_files
        ronn_files.map { |path| path.sub(/\.ronn$/, '.html') }
      end
    end

  end
end
