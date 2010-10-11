require 'tempfile'

module WorkingDirectory
  def setup
    @initial_directory = Dir.pwd
    @working_directory = Dir.mktmpdir
    Dir.chdir(@working_directory)
    super
  end

  def teardown
    super
    Dir.chdir(@initial_directory)
    FileUtils.remove_entry_secure(@working_directory)
  end
end

Shoe::TestCase.send(:include, WorkingDirectory)
