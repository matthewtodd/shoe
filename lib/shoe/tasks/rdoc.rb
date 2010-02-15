require 'rubygems/doc_manager'

module Shoe
  module Tasks

    class Rdoc < AbstractTask
      def define
        desc 'Generate documentation'
        task :rdoc do
          LocalDocManager.new(spec).generate_rdoc

          case RUBY_PLATFORM
          when /darwin/
            sh 'open rdoc/index.html'
          when /mswin|mingw/
            sh 'start rdoc\index.html'
          else
            sh 'firefox rdoc/index.html'
          end
        end
      end

      def should_define?
        File.directory?('lib')
      end

      def update_spec
        spec.files += Rake::FileList['**/*.rdoc', 'examples/**/*']

        spec.rdoc_options = %W(
          --main README.rdoc
          --title #{spec.full_name}
          --inline-source
        )

        spec.extra_rdoc_files += Rake::FileList['**/*.rdoc']

        spec.has_rdoc = true
      end

      private

      # Using Gem::DocManager instead of Rake::RDocTask means you get to see your
      # rdoc *exactly* as users who install your gem will.
      class LocalDocManager < Gem::DocManager #:nodoc:
        def initialize(spec)
          @spec      = spec
          @doc_dir   = Dir.pwd
          @rdoc_args = []
          adjust_spec_so_that_we_can_generate_rdoc_locally
        end

        def adjust_spec_so_that_we_can_generate_rdoc_locally
          def @spec.full_gem_path
            Dir.pwd
          end
        end
      end

    end

  end
end
