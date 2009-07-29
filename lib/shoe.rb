require 'rubygems/doc_manager'

# Shoe defines some handy Rake tasks for your project, all built around your Gem::Specification.
#
# Here's how you use it in your Rakefile:
#
#  require 'shoe'
#  Shoe.tie('myproject', '0.1.0', "This is my project, and it's awesome!") do |spec|
#    spec.add_development_dependency 'thoughtbot-shoulda'
#  end
#
# Shoe comes with an executable named "shoe" that will generate a Rakefile like this (but slightly fancier) for you.
class Shoe
  # Here's where you start. In your Rakefile, you'll probably just call
  # Shoe.tie, then add any dependencies in the block.
  def self.tie(name, version, summary)
    shoe = new(name, version, summary)
    yield shoe.spec if block_given?
    shoe.define_tasks
  end

  # The Gem::Specification for your project.
  attr_reader :spec

  # Initializes a Gem::Specification with some nice conventions.
  def initialize(name, version, summary)
    @spec = Gem::Specification.new do |spec|
      spec.name             = name
      spec.version          = version
      spec.summary          = summary
      spec.files            = FileList['Rakefile', '*.gemspec', '*.rdoc', 'bin/**/*', 'features/**/*', 'lib/**/*', 'resources/**/*', 'test/**/*'].to_a
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
        # MAYBE include -Iext. I think I'd like to wait until I handle C extensions in general.
        exec 'irb', '-Ilib', "-r#{spec.name}"
      end
    end

    if File.directory?('test')
      require 'rake/testtask'
      # MAYBE be a little more forgiving in test selection, using test/**/*_test.rb. Or create suites based on subdirectory?
      Rake::TestTask.new { |task| task.pattern = 'test/*_test.rb' }
      default_depends_on(:test)
    end

    if File.directory?('features')
      require 'cucumber/rake/task'
      Cucumber::Rake::Task.new('features', 'Run features')
      default_depends_on(:features)
    end

    if there_is_no_tag_for_the_current_version && we_are_on_the_master_branch && we_have_already_pushed_the_master_branch_to_a_remote_called_origin
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

  def there_is_no_tag_for_the_current_version
    !File.file?(".git/refs/tags/#{spec.version}")
  end

  def we_are_on_the_master_branch
    File.file?('.git/HEAD') && File.read('.git/HEAD').strip == 'ref: refs/heads/master'
  end

  def we_have_already_pushed_the_master_branch_to_a_remote_called_origin
    File.file?('.git/refs/remotes/origin/master')
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
