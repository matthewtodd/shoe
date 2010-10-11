require 'rubygems/validator'
require 'test/unit/ui/console/testrunner'

# Disable Test::Unit::AutoRunner.
#
# Though I tried to be really restrictive with the above testrunner require
# statement, test/unit itself still gets pulled in, activating the at_exit
# hook. Dang.
Test::Unit.run = true

module Shoe
  module Tasks

    # Defines <tt>`rake test`</tt> to run your tests.
    #
    # Uses
    # <tt>{Gem::Validator}[http://rubygems.rubyforge.org/rubygems-update/Gem/Validator.html]</tt>,
    # so tests are run locally just as they will be with <tt>`{gem
    # check}[http://docs.rubygems.org/read/chapter/10#page30] --test
    # your_project`</tt>.
    #
    # To enable and configure, edit the
    # <tt>test_files[http://docs.rubygems.org/read/chapter/20#test_files]</tt>
    # in your gemspec.
    #
    # = Use <tt>Test::Unit</tt>
    #
    # Using <tt>Gem::Validator</tt> means that only <tt>Test::Unit</tt> tests
    # will be run.
    #
    # = Be aware of the <tt>$LOAD_PATH</tt>
    #
    # At test time, the root of your gem, any
    # <tt>{require_paths}[http://docs.rubygems.org/read/chapter/20#require_paths]</tt>,
    # and any
    # <tt>{dependencies}[http://docs.rubygems.org/read/chapter/20#dependencies]</tt>
    # are on the <tt>$LOAD_PATH</tt>.
    #
    # <b>Wrong:</b>
    #
    #  # Don't do this; test_helper's not in the $LOAD_PATH
    #  require 'test_helper'
    #
    # <b>Right:</b>
    #
    #  require 'test/test_helper'
    #
    # = Pretty Colors
    #
    # If you like pretty colors (I do!), just <tt>require
    # '{redgreen}[http://rubygems.org/gems/redgreen]'</tt> in your tests. The
    # <tt>Gem::Validator</tt> has been configured to play nicely with it.
    #
    # <b>Wrong:</b>
    #
    #  # Don't do this; it breaks `gem check --test` if redgreen's not installed.
    #  require 'redgreen' if $stdout.tty?
    #
    # <b>Right:</b>
    #
    #  begin
    #    require 'redgreen' if $stdout.tty?
    #  rescue LoadError
    #    # No colors, but `gem check --test` is golden!
    #  end
    #
    class Test < Abstract
      def active?
        !spec.test_files.empty?
      end

      def define
        desc <<-END.gsub(/^ */, '')
          Run tests.
          Configure via the `test_files` field in #{spec.name}.gemspec.
        END

        task :test do
          Gem::Validator.extend(Extensions::Validator)
          Gem::Validator.new.unit_test(spec)
        end

        task :prepare

        task :test => :prepare

        task :default
        Rake.application[:default].prerequisites.unshift(Rake.application[:test])
      end
    end

  end
end
