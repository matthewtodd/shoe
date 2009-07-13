require 'pathname'
require 'rubygems/doc_manager'

require 'cucumber/rake/task'
require 'rake/testtask'

class Shoe
  def self.tie(name, version, summary)
    shoe = new(name, version, summary)
    yield shoe.spec if block_given?
    shoe.define_tasks
  end

  attr_reader :spec

  def initialize(name, version, summary)
    @spec = Gem::Specification.new do |spec|
      spec.name             = name
      spec.version          = version
      spec.summary          = summary
      spec.files            = FileList['Rakefile', '*.rdoc', 'bin/**/*', 'features/**/*', 'lib/**/*', 'test/**/*'].to_a
      spec.executables      = executables
      spec.rdoc_options     = %W(--main README.rdoc --title #{name}-#{version} --inline-source)
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

  def define_tasks
    desc 'Remove ignored files'
    task :clean do
      sh 'git clean -fdX'
    end

    desc 'Generate documentation'
    task :rdoc do
      DocManager.new(local_spec).generate_rdoc
    end

    if Pathname.pwd.join('test').directory?
      Rake::TestTask.new { |task| task.pattern = 'test/*_test.rb' }
      default_depends_on(:test)
    end

    if Pathname.pwd.join('features').directory?
      Cucumber::Rake::Task.new('features', 'Run features')
      default_depends_on(:features)
    end

    if system("[[ -z `git tag -l #{spec.version}` ]] && git branch | grep -q '* master' && git remote | grep -q origin")
      desc "Release #{spec.name}-#{spec.version}"
      task :release do
        File.open("#{spec.name}.gemspec", 'w') { |f| f.write spec.to_ruby }
        sh "git add #{spec.name}.gemspec"
        sh "git commit -a -m 'Release #{spec.version}'"
        sh "git tag #{spec.version}"
        sh 'git push --tags origin master'
      end
    end
  end

  private

  def default_depends_on(task_name)
    desc Rake.application.lookup(task_name).comment
    task :default => task_name
  end

  def executables
    bin = Pathname.pwd.join('bin')
    bin.directory? ? bin.children.map { |child| child.basename.to_s } : []
  end

  def local_spec
    local_spec = spec.dup
    def local_spec.full_gem_path
      Pathname.pwd
    end
    local_spec
  end

  class DocManager < Gem::DocManager #:nodoc:
    def initialize(spec)
      @spec      = spec
      @doc_dir   = Pathname.pwd
      @rdoc_args = []
    end
  end
end
