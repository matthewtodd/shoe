require 'open3'
require 'pathname'
require 'test/unit/assertions'
require 'tmpdir'

class WorkingDirectory
  PROJECT_ROOT = Pathname.new(File.expand_path('../../..', __FILE__))

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

  def isolate_environment(command)
    # set the PATH so tests can just run shoe
    ENV['PATH'] = ENV['PATH'].split(File::PATH_SEPARATOR).
                            unshift(PROJECT_ROOT.join('bin')).uniq.
                               join(File::PATH_SEPARATOR)
    ENV['RUBYLIB'] = PROJECT_ROOT.join('lib')

    # whack most environment variables for good hygiene
    "/usr/bin/env -i #{preserve_environment 'HOME', 'PATH', 'GEM_HOME', 'GEM_PATH', 'RUBYLIB'} #{command}"
  end

  def preserve_environment(*variables)
    variables.map { |name| "#{name}='#{ENV[name]}'" }.join(' ')
  end
end

World(Test::Unit::Assertions)
World  { WorkingDirectory.new }
Before { working_directory.mkpath }
After  { working_directory.rmtree }
