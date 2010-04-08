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
    # -- if you prefer Rspec[http://rspec.info], leave <tt>test_files</tt>
    # blank and set up your own Rake task. Easy peasy.
    #
    # = <tt>LOAD_PATH</tt>
    #
    # At test time, the root of your gem, any
    # <tt>{require_paths}[http://docs.rubygems.org/read/chapter/20#require_paths]</tt>,
    # and any
    # <tt>{dependencies}[http://docs.rubygems.org/read/chapter/20#dependencies]</tt>
    # are on the <tt>LOAD_PATH</tt>.
    #
    # <b>Bad:</b>
    #
    #  # Don't do this; test_helper's not in the LOAD_PATH
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
          Gem.source_index.extend(LocalGemSourceIndex)
          Gem.source_index.local_gemspec = spec

          Gem::Validator.send(:remove_const, :TestRunner)
          Gem::Validator.const_set(:TestRunner, LocalTestRunner)
          Gem::Validator.new.extend(LocalGemValidator).unit_test(spec)
        end

        before(:default, :test)
      end

      private

      module LocalGemSourceIndex #:nodoc:
        attr_accessor :local_gemspec

        def find_name(*args)
          if args.first == local_gemspec.name
            [local_gemspec]
          else
            super
          end
        end
      end

      module LocalGemValidator #:nodoc:
        def alert_error(*args)
          # no-op
        end

        def unit_test(*args)
          unless super.passed?
            exit 1
          end
        end
      end

      class LocalTestRunner < ::Test::Unit::UI::Console::TestRunner #:nodoc:
        def self.run(*args)
          new(args.first, ::Test::Unit::UI::NORMAL).start
        end
      end
    end

  end
end
