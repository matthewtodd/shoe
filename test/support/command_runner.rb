module CommandRunner
  attr_reader :stdout

  def system(command)
    IO.popen("#{command} 2>&1") { |io| @stdout = io.read }
    assert $?.success?, @stdout
  end
end

Shoe::TestCase.send(:include, CommandRunner)
