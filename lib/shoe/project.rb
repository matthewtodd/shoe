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
        spec.files            = FileList['Rakefile', 'bin/**/*', 'lib/**/*', 'resources/**/*', 'shoulda_macros/**/*']
        spec.executables      = everything_in_the_bin_directory
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
    end

    private

    def everything_in_the_bin_directory
      File.directory?('bin') ? Dir.entries('bin') - ['.', '..'] : []
    end
  end
end
