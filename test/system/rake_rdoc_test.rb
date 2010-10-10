require 'test/helper'

class RakeRdocTest < Test::Unit::TestCase
  def setup
    super
    system 'bundle gem foo'
    in_project 'foo'
    configure_project_for_shoe
  end

  test 'rake rdoc is unconditionally active' do
    assert_task 'rdoc'
  end

  test 'rake rdoc generates rdoc' do
    # Launchy runs BROWSER in a subshell, sending output to /dev/null, so if I
    # want to test it, I'm going to have to be more clever than this. For the
    # meantime, though, using /bin/echo at least keeps from opening a real
    # browser at test time.
    ENV['BROWSER'] = '/bin/echo'
    system 'rake rdoc'
    assert_file 'rdoc/index.html'
  end
end
