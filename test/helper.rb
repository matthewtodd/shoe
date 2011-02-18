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

Dir.chdir('test') do
  Dir['support/*.rb'].each { |path| require path }
end
