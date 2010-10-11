module CommandRunner
  attr_reader :output

  def system(command)
    IO.popen("#{command} 2>&1") { |io| @output = io.read.chomp }
    assert $?.success?, @output
    @output
  end
end

Shoe::TestCase.send(:include, CommandRunner)
