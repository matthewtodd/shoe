require 'test/unit'
require 'shoe'

class Shoe::TestCase < Test::Unit::TestCase
  def default_test
    # keep Test::Unit from complaining
  end

  def setup
    super
    system 'bundle gem foo'
    Dir.chdir('foo')
    configure_project_for_shoe
  end
end

Dir['test/support/*.rb'].each { |path| require path }
