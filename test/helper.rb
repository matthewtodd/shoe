require 'test/unit'
require 'shoe'

begin
  require 'redgreen' if $stdout.tty?
rescue LoadError
  # Since we don't have hard gem dependencies for testing, folks can run `gem
  # check --test shoe` without installing anything else.
end

module Shoe
  module TestExtensions
    autoload :HelperMethods,       'test/extensions/helper_methods'
    autoload :IsolatedEnvironment, 'test/extensions/isolated_environment'
    autoload :TestCase,            'test/extensions/test_case'
  end
end

Test::Unit::TestCase.extend(Shoe::TestExtensions::TestCase)
