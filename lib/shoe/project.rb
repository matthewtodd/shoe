require 'rubygems/ext'

module Shoe
  class Project

    # The Gem::Specification for your project.
    attr_reader :spec

    # Initializes a Gem::Specification with some nice conventions.
    def initialize(name, version, summary)
      @spec = Gem::Specification.new do |spec|
        spec.name             = name
        spec.version          = version
        spec.summary          = summary
        spec.files            = FileList['Rakefile', 'bin/**/*', 'ext/**/extconf.rb', 'ext/**/*.c', 'lib/**/*', 'resources/**/*', 'shoulda_macros/**/*']
        spec.executables      = everything_in_the_bin_directory
        spec.extensions       = FileList['ext/**/extconf.rb']
        spec.extra_rdoc_files = FileList['shoulda_macros/**/*']
        spec.author           = `git config --get user.name`.chomp
        spec.email            = `git config --get user.email`.chomp
      end
    end

    # This is where the magic happens.
    def define_tasks
      Shoe::Tasks.each do |task|
        task.define(spec)
      end

      desc 'Show latest gemspec contents'
      task :gemspec do
        puts spec.to_ruby
      end

      if File.directory?('ext')
        desc 'Compile C extensions'
        task :compile do
          top_level_path   = File.expand_path('.')
          destination_path = File.join(top_level_path, spec.require_paths.first)

          spec.extensions.each do |extension|
            Dir.chdir(File.dirname(extension)) do
              Gem::Ext::ExtConfBuilder.build(extension, top_level_path, destination_path, results = [])
            end
          end
        end

        [:test, :cucumber, 'cucumber:wip', :release].each do |task_name|
          if Rake.application.lookup(task_name)
            task task_name => :compile
          end
        end
      end
    end

    private

    def default_depends_on(task_name)
      desc Rake.application.lookup(task_name).comment
      task :default => task_name
    end

    def everything_in_the_bin_directory
      File.directory?('bin') ? Dir.entries('bin') - ['.', '..'] : []
    end
  end
end
