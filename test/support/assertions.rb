require 'pathname'

module Assertions
  def assert_file(path)
    assert Pathname.new(path).exist?, "#{path} does not exist."
  end

  def assert_file_removed(*expected, &block)
    files = find_files
    block.call
    assert_equal expected, files - find_files
  end

  def assert_task(expected)
    assert find_tasks.include?(expected)
  end

  def assert_task_added(*expected, &block)
    tasks = find_tasks
    block.call
    assert_equal expected, find_tasks - tasks
  end

  def assert_task_removed(*expected, &block)
    tasks = find_tasks
    block.call
    assert_equal expected, tasks - find_tasks
  end

  private

  def find_files
    pwd = Pathname.pwd
    pwd.enum_for(:find).
      select  { |path| path.file? }.
      collect { |path| path.relative_path_from(pwd) }.
      collect { |path| path.to_s }
  end

  def find_tasks
    system 'rake --tasks'
    stdout.lines.grep(/^rake (\S+)/).map { |line| line.split(' ')[1] }
  end
end

Shoe::TestCase.send(:include, Assertions)
