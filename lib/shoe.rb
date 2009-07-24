require 'rubygems'
require 'cucumber/rake/task'
require 'rake/testtask'
require 'rubygems/doc_manager'

class Shoe
  # Here's where you start. In your Rakefile, you'll probably just call
  # Shoe.tie, then add any dependencies in the block.
  def self.tie(name, version, summary)
    shoe = new(name, version, summary)
    yield shoe.spec if block_given?
    shoe.define_tasks
  end

  attr_reader :spec

  # Initializes a Gem::Specification with some nice conventions.
  def initialize(name, version, summary)
    @spec = Gem::Specification.new do |spec|
      spec.name             = name
      spec.version          = version
      spec.summary          = summary
      spec.files            = FileList['Rakefile', '*.rdoc', 'bin/**/*', 'features/**/*', 'lib/**/*', 'resources/**/*', 'test/**/*'].to_a
      spec.executables      = everything_in_the_bin_directory
      spec.rdoc_options     = %W(--main README.rdoc --title #{name}-#{version} --inline-source) # MAYBE include --all, so that we document private methods?
      spec.extra_rdoc_files = FileList['*.rdoc'].to_a
      spec.has_rdoc         = true
      spec.author           = `git config --get user.name`.chomp
      spec.email            = `git config --get user.email`.chomp
      spec.add_development_dependency 'matthewtodd-shoe'
    end

    def @spec.remove_development_dependency_on_shoe
      dependencies.delete_if { |d| d.name == 'matthewtodd-shoe' }
    end
  end

  # This is where the magic happens.
  def define_tasks
    desc 'Remove ignored files'
    task :clean do
      sh 'git clean -fdX'
    end

    desc 'Generate documentation'
    task :rdoc do
      LocalDocManager.new(spec).generate_rdoc
      sh 'open rdoc/index.html' if RUBY_PLATFORM =~ /darwin/
    end

    desc 'Run an irb console'
    task :shell do
      # MAYBE include -Iext. I think I'd like to wait until I handle C extensions in general.
      exec 'irb', '-Ilib', "-r#{spec.name}"
    end

    if File.directory?('test')
      Rake::TestTask.new { |task| task.pattern = 'test/*_test.rb' }
      default_depends_on(:test)
    end

    if File.directory?('features')
      Cucumber::Rake::Task.new('features', 'Run features')
      default_depends_on(:features)
    end

    if these_shell_commands_all_succeed(there_is_no_tag_for_the_current_version, we_are_on_the_master_branch, there_is_a_remote_called_origin)
      desc "Release #{spec.name}-#{spec.version}"
      task :release do
        File.open("#{spec.name}.gemspec", 'w') { |f| f.write spec.to_ruby }
        sh "git add #{spec.name}.gemspec"
        sh "git commit -a -m 'Release #{spec.version}'"
        sh "git tag #{spec.version}"
        sh 'git push'
        sh 'git push --tags'
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

  # I'm guessing it's a little faster shell out to all these commands
  # together, rather than running each one separately.
  def these_shell_commands_all_succeed(*commands)
    system(commands.join(' && '))
  end

  def there_is_no_tag_for_the_current_version
    "[[ -z `git tag -l #{spec.version}` ]]"
  end

  def we_are_on_the_master_branch
    "git branch | grep -q '* master'"
  end

  def there_is_a_remote_called_origin
    'git remote | grep -q origin'
  end

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
