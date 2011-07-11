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
    # (You may also want to add a <tt>.gemtest</tt> file to the root of your
    # gem, so that others can run your tests via
    # {rubygems-test}[https://github.com/rubygems/rubygems-test].)
    #
    # = A Few Precautions
    #
    # * Using <tt>testrb</tt> means that only <tt>Test::Unit</tt> (all
    #   Rubies) and <tt>MiniTest::Unit</tt> (Ruby 1.9) tests will be run.
    #
    # * You'll need to <tt>Bundler.setup(:default, :development)</tt> in your
    #   <tt>Rakefile</tt> so that <tt>testrb</tt> can find your code.
    #
    # * Your <tt>test_files</tt> need only contain actual tests -- support
    #   files, like test_helper, need not be included.
    #
    # * The <tt>LOAD_PATH</tt> will contain all of the immediate parent
    #   directories of your <tt>test_files</tt>. You should not count on the
    #   top-level project directory being included -- in other words,
    #   <tt>"require 'test/test_helper'"</tt> may not work, and <tt>"require
    #   'test_helper'"</tt> will only work if <tt>test_helper</tt> is a sibling
    #   of one of your <tt>test_files</tt>.
    #
    # For further clarification on these guidelines, you may find it helpful to
    # browse {Shoe's own test
    # setup}[https://github.com/matthewtodd/shoe/tree/master/test].
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
          system('testrb', *spec.test_files) || exit(1)
        end

        task :prepare

        task :test => :prepare

        task :default
        Rake.application[:default].prerequisites.unshift(Rake.application[:test])
      end
    end

  end
end
