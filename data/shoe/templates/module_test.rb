require 'test/helper'

class <%= module_name %>Test < Test::Unit::TestCase
  def test_dummy
    assert_equal '<%= version %>', <%= module_name %>::VERSION
  end
end
