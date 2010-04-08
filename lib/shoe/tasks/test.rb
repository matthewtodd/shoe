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
        def find_name(*args)
          if args.first == @local_gemspec.name
            [@local_gemspec]
          else
            super
          end
        end

        def local_gemspec=(local_gemspec)
          @local_gemspec = local_gemspec
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
