require 'tempfile'

module ExampleProject
  PATH = File.expand_path('../../..', __FILE__)

  attr_accessor :initial_directory
  attr_accessor :working_directory

  def setup
    self.initial_directory = Dir.pwd
    self.working_directory = Dir.mktmpdir

    Dir.chdir working_directory
    system 'bundle gem foo'
    Dir.chdir 'foo'

    prepend_file 'Gemfile',  "path '#{PATH}'"
    add_development_dependency 'shoe'
    append_file  'Rakefile', <<-END
      # need bundler setup only because shoe's a path dependency
      Bundler.setup(:default, :development)
      require 'shoe'
      Shoe.install_tasks
    END
  end

  def teardown
    Dir.chdir initial_directory
    FileUtils.remove_entry_secure working_directory
  end
end

Shoe::TestCase.send(:include, ExampleProject)
