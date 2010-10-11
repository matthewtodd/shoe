require 'test/helper'

class RakeCleanTest < Shoe::TestCase
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
end
