module Shoe
  module Tasks

    # Defines <tt>`rake test`</tt> to run your tests.
    #
    # Uses <tt>testrb</tt> to run your <tt>test_files</tt>.
    #
    # To enable and configure, edit the
    # <tt>test_files[http://docs.rubygems.org/read/chapter/20#test_files]</tt>
    # in your gemspec.
    #
    # = A Few Precautions
    #
    # * Using <tt>testrb</tt> means that only <tt>Test::Unit</tt> (all
    #   Rubies) and <tt>MiniTest::Unit</tt> (Ruby 1.9) tests will be run.
    #
    # * You'll need to <tt>Bundler.setup(:default, :development)</tt> in your
    #   <tt>Rakefile</tt> so that <tt>testrb</tt> can find your code.
    #
    # * The <tt>test</tt> directory will not be in the <tt>$LOAD_PATH</tt>, so
    #   you'll have to <tt>require 'test/test_helper'</tt>.
    #
    class Test < Task
      def active?
        !spec.test_files.empty?
      end

      def define
        desc <<-END.gsub(/^ */, '')
          Run tests.
          Configure via the `test_files` field in #{spec.name}.gemspec.
        END

        task :test do
          system 'testrb', *spec.test_files
        end

        task :prepare

        task :test => :prepare

        task :default
        Rake.application[:default].prerequisites.unshift(Rake.application[:test])
      end
    end

  end
end
