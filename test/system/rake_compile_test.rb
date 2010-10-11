require 'test/helper'

class RakeCompileTest < Shoe::TestCase
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
end
