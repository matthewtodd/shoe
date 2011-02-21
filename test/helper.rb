require 'test/unit'
require 'shoe'

if RUBY_VERSION >= '1.9' && $stdout.tty?
  require 'shoe/util/minitest_colors'
end

class Shoe::TestCase < Test::Unit::TestCase
  def default_test
    # keep Test::Unit from complaining
  end
end

require 'support/assertions'
require 'support/command_runner'
require 'support/declarative_tests'
require 'support/example_project'
require 'support/file_manipulation'
require 'support/gemspec_manipulation'
require 'support/project_files'
require 'support/redgreen'
