require 'rubygems/ext'

module Shoe
  module Tasks

    # Defines <tt>`rake compile`</tt> to build your C extensions.
    #
    # Uses
    # <tt>{Gem::Ext::ExtConfBuilder}[http://rubygems.rubyforge.org/rubygems-update/Gem/Ext/ExtConfBuilder.html]</tt>,
    # so extensions are compiled locally just as they will be with <tt>`gem
    # install`</tt>. Your users will thank you.
    #
    # To enable and configure, add
    # <tt>extensions[http://docs.rubygems.org/read/chapter/20#extensions]</tt>
    # to your gemspec.
    class Compile < Abstract
      def active?
        !spec.extensions.empty?
      end

      def define
        desc <<-END.gsub(/^ */, '')
          Compile C extensions.
          Configure via the `extensions` field in #{spec.name}.gemspec.
        END

        task :compile do
          top_level_path   = File.expand_path('.')
          destination_path = File.join(top_level_path, spec.require_paths.first)

          spec.extensions.each do |extension|
            Dir.chdir File.dirname(extension) do
              Gem::Ext::ExtConfBuilder.build(
                extension,
                top_level_path,
                destination_path,
                results = []
              )
            end
          end
        end

        namespace :prepare do
          task :execute => :compile
        end
      end
    end

  end
end
