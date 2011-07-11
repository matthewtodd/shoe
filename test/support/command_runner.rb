module CommandRunner
  attr_reader :output

  def system(command, expected_success = true)
    IO.popen("#{command} 2>&1") { |io| @output = io.read.chomp }
    assert_equal expected_success, $?.success?, @output
    @output
  end
end

Shoe::TestCase.send(:include, CommandRunner)
