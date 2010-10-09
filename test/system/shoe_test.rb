require 'test/helper'

class ShoeTest < Test::Unit::TestCase
  isolate_environment
  include_helper_methods

  test 'running without arguments generates files named after the current directory' do
    Dir.mkdir 'existing_project'
    Dir.chdir 'existing_project'
    system 'shoe'
    assert_find '.', %w(
      .gitignore
      Gemfile
      README.rdoc
      Rakefile
      existing_project.gemspec
      lib/existing_project.rb
      lib/existing_project/version.rb
      man/existing_project.3.ronn
      test/helper.rb
      test/existing_project_test.rb
    )
  end

  test 'running with a path generates files named after the path' do
    system 'shoe new_project'
    assert_file 'new_project/new_project.gemspec'
  end

  test 'running in an existing project does not clobber existing files' do
    in_project 'existing_project'
    write_file 'Rakefile', '# original'
    system 'shoe'
    assert_equal '# original', File.read('Rakefile')
  end

  test 'running produces a buildable gemspec' do
    in_project 'foo'
    system 'shoe'
    system 'gem build foo.gemspec'
    assert_file 'foo-0.0.0.gem'
  end

  test 'running generates a module with a VERSION constant' do
    in_project 'foo'
    system 'shoe'
    system 'ruby -Ilib -rfoo -e "puts Foo::VERSION"'
    assert_equal '0.0.0', stdout.chomp
  end

  test 'running --application generates an executable script' do
    in_project 'foo'
    system 'shoe --application'
    system './bin/foo --version'
    assert_match 'foo 0.0.0', stdout.chomp
  end

  test 'running --data generates a datadir helper method' do
    in_project 'foo'
    system 'shoe --data'
    write_file 'data/foo/file', 'DATA!'
    system 'ruby -Ilib -rfoo -e "puts Foo.datadir.join(\"file\").read"'
    assert_match 'DATA!', stdout.chomp
  end

  test 'running --extension generates an Extension' do
    in_project 'foo'
    system 'shoe --extension'
    Dir.chdir('ext/foo') { system 'ruby extconf.rb && make' }
    system 'ruby -Ilib -Iext -rfoo -e "puts Foo::Extension.name"'
    assert_equal 'Foo::Extension', stdout.chomp
  end

  test 'running --test generates passing tests' do
    in_project 'foo'
    system 'shoe --test'
    system 'testrb -I. -Ilib test/*_test.rb'
    assert_match '1 tests, 1 assertions, 0 failures, 0 errors', stdout
  end
end
