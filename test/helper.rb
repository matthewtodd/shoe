require 'test/unit'
require 'shoe'

begin
  require 'redgreen' if $stdout.tty?
rescue LoadError
  # Since we don't have hard gem dependencies for testing, folks can run `gem
  # check --test shoe` without installing anything else.
end

require 'test/extensions/helper_methods'
require 'test/extensions/isolated_environment'
require 'test/extensions/test_case'

class Test::Unit::TestCase
  extend Shoe::TestExtensions::TestCase

  include Shoe::TestExtensions::IsolatedEnvironment
  include Shoe::TestExtensions::HelperMethods
end
