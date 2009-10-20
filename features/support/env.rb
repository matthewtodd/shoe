require 'open3'
require 'pathname'
require 'tmpdir'

class WorkingDirectory
  PROJECT_ROOT = Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..')))

  attr_reader :working_directory
  attr_reader :standard_out
  attr_reader :standard_error

  def initialize
    @working_directory = Pathname.new(Dir.mktmpdir)
  end

  def create_directory(path)
    file(path).mkpath
  end

  def create_file(path, contents)
    file(path).open('w') { |file| file.write(contents) }
  end

  def edit_file(path, search, replace)
    old_contents = file(path).read
    new_contents = old_contents.gsub(search, replace)
    create_file(path, new_contents)
  end

  def file(path)
    working_directory.join(path)
  end

  def run(command, path)
    Dir.chdir(working_directory.join(path)) do
      Open3.popen3(rejigger_the_path(command)) do |stdin, stdout, stderr|
        @standard_out   = stdout.read
        @standard_error = stderr.read
      end
    end
  end

  private

  def rejigger_the_path(command)
    "/usr/bin/env PATH='#{PROJECT_ROOT.join('bin')}:#{ENV['PATH']}' RUBYLIB='#{PROJECT_ROOT.join('lib')}' #{command}"
  end
end

World  { WorkingDirectory.new }
Before { working_directory.mkpath }
After  { working_directory.rmtree }
