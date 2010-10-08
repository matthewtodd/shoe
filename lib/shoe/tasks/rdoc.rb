require 'rubygems/doc_manager'
require 'launchy'

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
        desc <<-END.gsub(/^ */, '')
          Generate documentation.
          Configure via the `rdoc_options` and `extra_rdoc_files` fields in
          #{spec.name}.gemspec. Open in a different browser by setting the
          BROWSER environment variable.
        END
        task :rdoc do
          Gem::DocManager.new(spec).extend(Extensions::DocManager).generate_rdoc
          Browser.run('rdoc/index.html')
        end
      end
    end

  end
end
