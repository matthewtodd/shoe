require 'rubygems/ext'

module Shoe
  module Tasks

    class Compile < AbstractTask
      def define
        desc 'Compile C extensions'
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

        %w(
          test
          cucumber:ok
          cucumber:wip
          release
        ).each do |name|
          before_existing(name, :compile)
        end
      end

      def should_define?
        File.directory?('ext')
      end

      def update_spec
        spec.files      += Rake::FileList['ext/**/extconf.rb', 'ext/**/*.c']
        spec.extensions += Rake::FileList['ext/**/extconf.rb']
      end
    end

  end
end
