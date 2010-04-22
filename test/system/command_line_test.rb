require 'test/helper'

class CommandLineTest < Test::Unit::TestCase
  isolate_environment

  test 'running without arguments should produce files named after the directory' do
    Dir.mkdir('my_project')
    Dir.chdir('my_project')

    system 'shoe'

    assert_equal %w(
      .gitignore
      README.rdoc
      Rakefile
      lib/my_project.rb
      my_project.gemspec
      test/helper.rb
      test/my_project_test.rb
    ), find('.')
  end
end
