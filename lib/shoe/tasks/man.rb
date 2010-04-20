module Shoe
  module Tasks

    # Defines <tt>`rake man`</tt> to generate man pages from
    # {ronn}[http://rtomayko.github.com/ronn/] sources.
    #
    # To enable, create a <tt>man/.*.ronn</tt> file.
    #
    # To configure the <tt>organization</tt> field for your man pages, set the
    # first of the
    # <tt>authors[http://docs.rubygems.org/read/chapter/20#authors]</tt>
    # in your gemspec.
    #
    # == Notes
    #
    # * It's best to check the generated man pages into version control so
    #   they'll be included in your gem for
    #   {gem-man}[http://github.com/defunkt/gem-man].
    #
    # * Man is a prerequisite for Release, so your man pages are sure to be
    #   up-to-date.
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
