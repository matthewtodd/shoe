require 'pathname'

module Assertions
  def assert_file(path)
    assert Pathname.new(path).exist?, "#{path} does not exist."
  end

  def assert_files_removed(*expected, &block)
    files = find_files
    block.call
    assert_equal expected, files - find_files
  end

  def assert_no_task(name)
    system 'rake --tasks'
    assert_no_match /\srake #{name}\s/, stdout
  end

  def assert_task(name)
    system 'rake --tasks'
    assert_match /\srake #{name}\s/, stdout
  end

  private

  def find_files
    pwd = Pathname.pwd
    pwd.enum_for(:find).
      select  { |path| path.file? }.
      collect { |path| path.relative_path_from(pwd) }.
      collect { |path| path.to_s }
  end
end

Shoe::TestCase.send(:include, Assertions)
