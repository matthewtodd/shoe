require 'test/unit'
require 'shoe'

module Shoe
  module TestExtensions
    autoload :FakeRubygemsServer,  'test/extensions/fake_rubygems_server'
    autoload :HelperMethods,       'test/extensions/helper_methods'
    autoload :IsolatedEnvironment, 'test/extensions/isolated_environment'
    autoload :TestCase,            'test/extensions/test_case'
  end
end

Test::Unit::TestCase.extend(Shoe::TestExtensions::TestCase)
