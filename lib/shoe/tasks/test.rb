require 'rubygems/validator'

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
          Gem::Validator.new.unit_test(spec)
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
    end

  end
end
