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

class Shoe::TestCase < Test::Unit::TestCase
  include Shoe::TestExtensions::IsolatedEnvironment
  include Shoe::TestExtensions::HelperMethods

  class << self
    def pending(name, options={}, &block)
      warn "WARN: Pending test \"#{name}\""
    end

    def test(name, options={}, &block)
      if !block_given?
        pending(name, options, &block)
        return
      end

      requires = Array(options[:require])

      requires.each do |lib|
        begin
          require lib
        rescue LoadError
          warn "WARN: #{lib} is not available.\n  Skipping test \"#{name}\""
          return
        end
      end

      define_method("test #{name}", &block)
    end
  end

  def default_test
    # keep Test::Unit from complaining
  end
end
