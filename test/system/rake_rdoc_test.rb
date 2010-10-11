require 'test/helper'

class RakeRdocTest < Shoe::TestCase
  it 'is unconditionally active' do
    assert_task 'rdoc'
  end

  it 'generates rdoc' do
    # Launchy runs BROWSER in a subshell, sending output to /dev/null, so if I
    # want to test it, I'm going to have to be more clever than this. For the
    # meantime, though, using /bin/echo at least keeps from opening a real
    # browser at test time.
    ENV['BROWSER'] = '/bin/echo'
    system 'rake rdoc'
    assert_file 'rdoc/index.html'
  end
end
