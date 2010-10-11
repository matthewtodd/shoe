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
    # * It's best to include the generated man pages in your gem, so that
    #   {gem-man}[http://github.com/defunkt/gem-man] can get to them.
    #
    # * Ronn becomes a prerequisite for <tt>rake build</tt>, so your man pages
    #   are sure to be up-to-date.
    #
    # * You may like to add a <tt>task :man => :ronn</tt> to your
    #   <tt>Rakefile</tt>. I felt a little uncomfortable clogging that
    #   namespace without your consent.
    class Ronn < Task
      def active?
        !ronn_files.empty?
      end

      def define
        begin
          require 'ronn'
        rescue LoadError
          warn "WARN: Please `gem install ronn`."
        else
          define_tasks
        end
      end

      private

      def define_tasks
        desc <<-END.gsub(/^ */, '')
          Generate man pages.
          Configure via the `date` and `authors` fields in #{spec.name}.gemspec.
          Uses ronn sources in man/*.ronn.
        END

        task :ronn => 'ronn:build' do
          sh 'man', *man_files
        end

        namespace :ronn do
          task :build => man_files
        end

        rule /\.\d$/ => '%p.ronn' do |task|
          ronn('--roff', task.source)
        end

        if Rake::Task.task_defined?(:build)
          task :build => 'ronn:build'
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
