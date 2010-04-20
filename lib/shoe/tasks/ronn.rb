module Shoe
  module Tasks

    # Defines <tt>`rake ronn`</tt> to generate man pages from your
    # <tt>{ronn}[http://rtomayko.github.com/ronn/]</tt> sources.
    #
    # To enable, create some <tt>man/*.ronn</tt> files.
    #
    # To configure the <tt>date</tt> and <tt>organization</tt> fields for your man pages, set the
    # <tt>date[http://docs.rubygems.org/read/chapter/20#date]</tt>
    # and the first of the
    # <tt>authors[http://docs.rubygems.org/read/chapter/20#authors]</tt>
    # in your gemspec, respectively.
    #
    # == Notes
    #
    # * It's best to check the generated man pages into version control so
    #   they'll be included in your gem for
    #   {gem-man}[http://github.com/defunkt/gem-man].
    #
    # * Ronn becomes a prerequisite for Release, so your man pages are sure to
    #   be up-to-date.
    #
    # * You may like to add a <tt>task :man => :ronn</tt> to your
    #   <tt>Rakefile</tt>. I felt a little uncomfortable clogging that
    #   namespace without your consent.
    class Ronn < Abstract
      def active?
        !ronn_files.empty?
      end

      def define
        begin
          require 'ronn'
        rescue LoadError
          warn "It seems you don't have 'ronn' installed."
        else
          define_tasks
        end
      end

      private

      def define_tasks
        desc 'Generate man pages'
        task :ronn => 'ronn:build' do
          sh 'man', *man_files
        end

        namespace :ronn do
          task :build => man_files
        end

        rule /\.\d$/ => '%p.ronn' do |task|
          ronn('--roff', task.source)
        end

        namespace :prepare do
          task :release => 'ronn:build'
        end
      end

      def ronn(format, file)
        sh "ronn --build #{format} --date #{spec.date.strftime('%Y-%m-%d')} --manual='RubyGems Manual' --organization='#{spec.author}' #{file}"
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
