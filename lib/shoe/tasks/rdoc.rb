require 'rubygems/doc_manager'

module Shoe
  module Tasks

    # Defines <tt>`rake rdoc`</tt> to generate project documentation.
    #
    # Uses
    # <tt>{Gem::DocManager}[http://rubygems.rubyforge.org/rubygems-update/Gem/DocManager.html]</tt>,
    # so rdoc is generated locally just as it will be with <tt>`gem
    # install`</tt> and <tt>`gem rdoc`</tt>. Your users will thank you for
    # making sure their local documentation looks nice.
    #
    # (Incidentally, this is why Shoe prefers rdoc (the file format) over
    # Markdown[http://daringfireball.net/projects/markdown/] and rdoc (the
    # tool) over YARD[http://yardoc.org/], even though both have considerable
    # advantages -- it's what your users are going to get!)
    #
    # This task is always enabled.
    #
    # To configure, add
    # <tt>rdoc_options[http://docs.rubygems.org/read/chapter/20#rdoc_options]</tt> and
    # <tt>extra_rdoc_files[http://docs.rubygems.org/read/chapter/20#extra_rdoc_files]</tt>
    # to your gemspec.
    class Rdoc < Abstract
      def active?
        true
      end

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
