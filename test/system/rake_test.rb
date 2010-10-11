require 'test/helper'

class RakeTest < Shoe::TestCase
  describe 'rake clean' do
    it 'is active only if there is a .git directory' do
      assert_task 'clean'
      system 'mv .git .git.bak'
      assert_no_task 'clean'
    end

    it 'removes ignored files, excluding .bundler' do
      write_file '.gitignore',        ".bundle\nbar"
      write_file '.bundle/config.rb', '# will remain'
      write_file 'bar',               'will be deleted'
      assert_files_removed 'bar' do
        system 'rake clean'
      end
    end
  end

  describe 'rake compile' do
    it 'is active only if there are extensions' do
      assert_no_task 'compile'
      add_files_for_c_extension
      assert_task 'compile'
    end

    it 'builds extensions' do
      add_files_for_c_extension
      system 'rake compile'
      system 'ruby -Ilib -rfoo/extension -e "puts Foo::Extension.name"'
      assert_equal 'Foo::Extension', stdout.chomp
    end
  end

  describe 'rake cucumber' do
    requires 'cucumber' do
      it 'is active only if there are profiles in cucumber.yml' do
        add_development_dependency 'cucumber'
        assert_no_task 'cucumber'
        add_files_for_cucumber
        assert_task 'cucumber'
        assert_task 'cucumber:wip'
      end

      it 'runs cucumber features' do
        add_development_dependency 'cucumber'
        add_files_for_cucumber
        system 'rake cucumber'
        assert_match '1 scenario (1 passed)', stdout
      end

      it 'depends on rake compile' do
        add_development_dependency 'cucumber'
        add_files_for_c_extension
        add_files_for_cucumber 'require "foo/extension"'
        system 'rake cucumber'
        assert_match '1 scenario (1 passed)', stdout
      end
    end
  end

  describe 'rake rdoc' do
    it 'is unconditionally active' do
      assert_task 'rdoc'
    end

    it 'generates rdoc' do
      # Launchy runs BROWSER in a subshell, sending output to /dev/null, so if
      # I want to test it, I'm going to have to be more clever than this. For
      # the meantime, though, using /bin/echo at least keeps from opening a
      # real browser at test time.
      ENV['BROWSER'] = '/bin/echo'
      system 'rake rdoc'
      assert_file 'rdoc/index.html'
    end
  end

  describe 'rake ronn' do
    requires 'ronn' do
      it 'is enabled if there are ronn files' do
        add_development_dependency 'ronn'
        assert_no_task 'ronn'
        add_files_for_ronn
        assert_task 'ronn'
      end

      it 'generates man pages' do
        ENV['MANPAGER'] = '/bin/cat'
        add_development_dependency 'ronn'
        add_files_for_ronn
        system 'rake ronn'
        assert_file 'man/foo.3'
        assert_match 'FOO(3)', stdout.chomp
      end

      it 'registers itself as a prerequisite of rake build' do
        add_development_dependency 'ronn'
        add_files_for_ronn
        mask_gemspec_todos
        system 'rake build --trace'
        assert_file 'man/foo.3'
      end
    end
  end

  describe 'rake test' do
    it 'is active only if there are test files present' do
      assert_no_task 'test'
      add_files_for_test
      assert_task 'test'
    end

    it 'runs tests' do
      add_files_for_test
      system 'rake test'
      assert_match '1 tests, 1 assertions, 0 failures, 0 errors', stdout
    end

    it 'depends (perhaps indirectly) on rake compile' do
      add_files_for_c_extension
      add_files_for_test 'require "foo/extension"'
      system 'rake test'
      assert_match '1 tests, 0 assertions, 0 failures, 0 errors', stdout
    end
  end
end
