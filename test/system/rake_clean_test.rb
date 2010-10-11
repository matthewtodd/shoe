require 'test/helper'

class RakeCleanTest < Shoe::TestCase
  test 'rake clean is active only if there is a .git directory' do
    assert_task 'clean'
    system 'mv .git .git.bak'
    assert_no_task 'clean'
  end

  test 'rake clean removes ignored files, excluding .bundler' do
    system 'git init'

    write_file '.gitignore', <<-END.gsub(/^ */, '')
      .bundle
      bar
    END

    write_file '.bundle/config.rb', '# STAYING ALIVE'
    write_file 'bar',               'NOT LONG FOR THIS WORLD'

    files_before_clean = find('.')
    system 'rake clean'
    assert_find  '.', files_before_clean - ['bar'] + ['Gemfile.lock']
  end
end
