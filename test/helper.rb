require 'test/unit'
require 'tempfile'
require 'shoe'

begin
  require 'redgreen' if $stdout.tty?
rescue LoadError
  # Since we don't have hard gem dependencies for testing, folks can run `gem
  # check --test shoe` without installing anything else.
end

require 'test/extensions/helper_methods'
require 'test/extensions/isolated_environment'

class Shoe::TestCase < Test::Unit::TestCase
  include Shoe::TestExtensions::HelperMethods
  include Shoe::TestExtensions::IsolatedEnvironment

  class << self
    def skip(name, options={}, &block)
      warn "Skipping test \"#{name}\""
    end

    def test(name, options={}, &block)
      Array(options[:require]).each do |lib|
        begin
          require lib
        rescue LoadError
          skip(name)
          return
        end
      end

      define_method("test #{name}", &block)
    end
  end

  def default_test
    # keep Test::Unit from complaining
  end

  def setup
    super
    system 'bundle gem foo'
    in_project 'foo'
    configure_project_for_shoe
  end
end
