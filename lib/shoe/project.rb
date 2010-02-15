require 'rubygems/doc_manager'
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
        spec.files            = FileList['Rakefile', '*.gemspec', '**/*.rdoc', 'bin/**/*', 'examples/**/*', 'ext/**/extconf.rb', 'ext/**/*.c', 'features/**/*', 'lib/**/*', 'resources/**/*', 'shoulda_macros/**/*', 'test/**/*'].to_a
        spec.executables      = everything_in_the_bin_directory
        spec.extensions       = FileList['ext/**/extconf.rb'].to_a
        spec.rdoc_options     = %W(--main README.rdoc --title #{name}-#{version} --inline-source) # MAYBE include --all, so that we document private methods?
        spec.extra_rdoc_files = FileList['**/*.rdoc', 'shoulda_macros/**/*'].to_a
        spec.has_rdoc         = true
        spec.author           = `git config --get user.name`.chomp
        spec.email            = `git config --get user.email`.chomp
      end
    end

    # This is where the magic happens.
    def define_tasks
      if File.directory?('.git')
        desc 'Remove ignored files'
        task :clean do
          sh 'git clean -fdX'
        end
      end

      if File.directory?('lib')
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

      if File.file?("lib/#{spec.name}.rb")
        desc 'Run an irb console'
        task :shell do
          exec 'irb', '-Ilib', "-r#{spec.name}"
        end
      end

      if File.directory?('test')
        require 'rake/testtask'
        # MAYBE be a little more forgiving in test selection, using test/**/*_test.rb. Or create suites based on subdirectory?
        Rake::TestTask.new do |task|
          task.libs    = ['lib', 'test']
          task.pattern = 'test/*_test.rb'
        end
        default_depends_on(:test)
      end

      if File.directory?('features')
        begin
          require 'cucumber/rake/task'
        rescue LoadError
          # no cuke for you
        else
          Cucumber::Rake::Task.new(:cucumber, 'Run features') { |task| task.cucumber_opts = '--tags ~@wip' }
          default_depends_on(:cucumber)

          if there_are_any_work_in_progress_features
            namespace :cucumber do
              Cucumber::Rake::Task.new(:wip, 'Run work-in-progress features') { |task| task.cucumber_opts = '--tags @wip --wip' }
            end
          end
        end
      end

      desc 'Show latest gemspec contents'
      task :gemspec do
        puts spec.to_ruby
      end

      if releasable?
        desc "Release #{spec.name}-#{spec.version}"
        task :release do
          File.open("#{spec.name}.gemspec", 'w') do |stream|
            stream.write(spec.to_ruby)
          end

          sh "git add #{spec.name}.gemspec"
          sh "git commit -a -m 'Release #{spec.version}'"
          sh "git tag #{version_tag(spec.version)}"

          if there_is_no_tag_for('semver')
            sh 'git tag semver'
          end

          if there_is_a_remote_called('origin')
            sh 'git push origin master'
            sh 'git push --tags origin'
          end

          sh "gem build #{spec.name}.gemspec"
          if Gem::CommandManager.instance.command_names.include?('push')
            sh "gem push #{spec.file_name}"
          end
        end
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

    def releasable?
      spec.version > Gem::Version.new('0.0.0') &&
        there_is_no_tag_for(version_tag(spec.version)) &&
        we_are_on_the_master_branch
    end

    def there_are_any_work_in_progress_features
      Dir.glob('features/**/*.feature').detect do |path|
        File.read(path).include?('@wip')
      end
    end

    def there_is_no_tag_for(tag)
      !`git tag`.to_a.include?("#{tag}\n")
    end

    def version_tag(version)
      "v#{spec.version}"
    end

    def we_are_on_the_master_branch
      `git symbolic-ref HEAD`.strip == 'refs/heads/master'
    end

    def there_is_a_remote_called(name)
      `git remote`.to_a.include?("#{name}\n")
    end

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
