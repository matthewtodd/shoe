require 'test/unit'
require 'shoe'

class Shoe::TestCase < Test::Unit::TestCase
  def default_test
    # keep Test::Unit from complaining
  end
end

Dir['test/support/*.rb'].each { |path| require path }
