require 'helper'

class RakeTest < Shoe::TestCase
  describe 'rake clean' do
    it 'is active only if there is a .git directory' do
      assert_task_removed 'clean' do
        system 'mv .git .git.bak'
      end
    end

    it 'removes ignored files, excluding .bundler' do
      write_file '.gitignore',     ".bundle\nbar"
      write_file '.bundle/foo.rb', 'will remain'
      write_file 'bar',            'will be deleted'
      assert_file_removed 'bar' do
        system 'rake clean'
      end
    end
  end

  describe 'rake compile' do
    it 'is active only if there are extensions' do
      assert_task_added 'compile' do
        add_files_for_c_extension
      end
    end

    it 'builds extensions' do
      add_files_for_c_extension
      system 'rake compile'
      system 'ruby -Ilib -rfoo/extension -e "puts Foo::Extension.name"'
      assert_equal 'Foo::Extension', output
    end
  end

  describe 'rake cucumber' do
    requires 'cucumber' do
      it 'is active only if there are profiles in cucumber.yml' do
        add_development_dependency 'cucumber'
        assert_task_added 'cucumber', 'cucumber:wip' do
          add_files_for_cucumber
        end
      end

      it 'runs cucumber features' do
        add_development_dependency 'cucumber'
        add_files_for_cucumber
        system 'rake cucumber'
        assert_match '1 scenario (1 passed)', output
      end

      it 'depends (perhaps indirectly) on rake compile' do
        add_development_dependency 'cucumber'
        add_files_for_c_extension
        add_files_for_cucumber 'require "foo/extension"'
        system 'rake cucumber'
        assert_match '1 scenario (1 passed)', output
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
      system 'BROWSER=/bin/echo rake rdoc'
      assert_file 'rdoc/index.html'
    end
  end

  describe 'rake ronn' do
    requires 'ronn' do
      it 'is enabled if there are ronn files' do
        add_development_dependency 'ronn'
        assert_task_added 'ronn' do
          add_files_for_ronn
        end
      end

      it 'generates man pages' do
        add_development_dependency 'ronn'
        add_files_for_ronn
        system 'MANPAGER=/bin/cat rake ronn'
        assert_file 'man/foo.3'
        assert_match 'FOO(3)', output
      end

      it 'registers itself as a prerequisite of rake build' do
        add_development_dependency 'ronn'
        add_files_for_ronn
        mask_gemspec_todos
        system 'rake build'
        assert_file 'man/foo.3'
      end
    end
  end

  describe 'rake test' do
    it 'is active only if there are test files present' do
      assert_task_added 'test' do
        add_files_for_test
      end
    end

    it 'runs tests' do
      add_files_for_test
      system 'rake test'
      assert_match '1 tests, 1 assertions, 0 failures, 0 errors', output
    end

    it 'depends (perhaps indirectly) on rake compile' do
      add_files_for_c_extension
      add_files_for_test 'require "foo/extension"'
      system 'rake test'
      assert_match '1 tests, 0 assertions, 0 failures, 0 errors', output
    end
  end
end
