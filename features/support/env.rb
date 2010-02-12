require 'open3'
require 'pathname'
require 'shellwords'
require 'test/unit/assertions'
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
    file(path).open('w') { |file| file.write(be_sneaky_with_the_gemfile(contents)) }
  end

  def append_file(path, contents)
    file(path).open('a') { |file| file.write(contents) }
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
      Open3.popen3(isolate_environment(command)) do |stdin, stdout, stderr|
        @standard_out   = stdout.read
        @standard_error = stderr.read
      end
    end
  end

  private

  def be_sneaky_with_the_gemfile(contents)
    contents.sub("gem 'shoe'", "gem 'shoe', :path => '#{Pathname.pwd.expand_path}'")
  end

  # bundle exec rake running from bundle exec cucumber otherwise gets confused
  # about where the real Gemfile is.
  # TODO tests may be slow because of all the bash login shells. So maybe I can just inherit the PATH and be okay?
  def isolate_environment(command)
    "/usr/bin/env -i HOME=#{ENV['HOME']} /bin/bash -l -c #{Shellwords.escape(command)}"
  end
end

World(Test::Unit::Assertions)
World  { WorkingDirectory.new }
Before { working_directory.mkpath }
After  { working_directory.rmtree }
