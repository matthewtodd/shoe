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
    # (Incidentally, this ensures your tests _are_ runnable via <tt>`gem
    # check`</tt>, a forgotten command second only to <tt>`{gem
    # cert}[http://docs.rubygems.org/read/chapter/10#page93]`</tt> in its
    # underuse.)
    #
    # To enable and configure, edit the
    # <tt>test_files[http://docs.rubygems.org/read/chapter/20#test_files]</tt>
    # in your gemspec.
    #
    # = <tt>Test::Unit</tt>
    #
    # Using <tt>Gem::Validator</tt> in this way means that you *must* use
    # <tt>Test::Unit</tt> in all of your
    # <tt>test_files[http://docs</tt>.rubygems.org/read/chapter/20#test_files]
    # -- if you prefer Rspec[http://rspec.info], just leave <tt>test_files</tt>
    # blank and set up your own Rake task.
    #
    # = <tt>$LOAD_PATH</tt>
    #
    # At test time, the root of your gem, any
    # <tt>{require_paths}[http://docs.rubygems.org/read/chapter/20#require_paths]</tt>,
    # and any
    # <tt>{dependencies}[http://docs.rubygems.org/read/chapter/20#dependencies]</tt>
    # are on the <tt>$LOAD_PATH</tt>.
    #
    # <b>Bad:</b>
    #
    #  # Don't do this; test_helper's not in the $LOAD_PATH
    #  require 'test_helper'
    #
    # <b>Good:</b>
    #
    #  require 'test/test_helper'
    #
    class Test < Abstract
      def active?
        !spec.test_files.empty?
      end

      def define
        desc 'Run tests'
        task :test do
          Gem.source_index.extend(Extensions::SourceIndex)
          Gem.source_index.local_gemspec = spec

          Gem::Validator.send(:remove_const, :TestRunner)
          Gem::Validator.const_set(:TestRunner, test_runner_class)
          Gem::Validator.new.extend(Extensions::Validator).unit_test(spec)
        end

        namespace :prepare do
          task :execute
        end

        task :test => 'prepare:execute'

        task :default
        Rake.application[:default].prerequisites.unshift(Rake.application[:test])
      end

      private

      def test_runner_class
        ::Test::Unit::UI::Console::TestRunner.extend(Extensions::TestRunner)
      end
    end

  end
end
