require 'rubygems/doc_manager'

module Shoe
  module Tasks

    class Rdoc < Abstract
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

      private

      # Using Gem::DocManager instead of Rake::RDocTask means you get to see your
      # rdoc *exactly* as users who install your gem will.
      class LocalDocManager < Gem::DocManager #:nodoc:
        def initialize(spec)
          @spec      = spec
          @doc_dir   = Dir.pwd
          @rdoc_args = []
        end
      end
    end

  end
end
