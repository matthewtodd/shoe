require 'test/helper'

class RakeRonnTest < Shoe::TestCase
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
end
