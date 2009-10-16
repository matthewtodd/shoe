require 'open3'
require 'pathname'
require 'tmpdir'

class Command
  def self.run(command_line)
    command = new(command_line)
    command.run
    command
  end

  attr_reader :out
  attr_reader :err

  def initialize(command)
    @command = command
  end

  def run
    Open3.popen3(@command) do |stdin, stdout, stderr|
      @out = stdout.read
      @err = stderr.read
    end
  end
end

class ShoeWorld
  SHOE_BINARY = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'shoe'))

  def create_directory(name)
    working_directory.join(name).mkpath
  end

  def create_file(path, contents)
    working_directory.join(path).open('w') { |file| file.write(contents) }
  end

  def inside_directory(name)
    Dir.chdir(working_directory.join(name)) { yield }
  end

  def working_directory
    @working_directory ||= Pathname.new(Dir.mktmpdir)
  end

  def run_shoe
    @last_command = Command.run(SHOE_BINARY)
  end

  def error_stream
    @last_command.err
  end

  def file(path)
    working_directory.join(path)
  end
end

World  { ShoeWorld.new }
Before { working_directory.mkpath }
After  { working_directory.rmtree }