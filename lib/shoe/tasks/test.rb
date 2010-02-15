require 'rake/testtask'

module Shoe
  module Tasks

    # MAYBE be a little more forgiving in test selection, using
    # test/**/*_test.rb. Or create suites based on subdirectory?
    class Test < AbstractTask
      def define
        Rake::TestTask.new do |task|
          task.libs    = ['lib', 'test']
          task.pattern = 'test/*_test.rb'
        end

        before(:default, :test)
      end

      def should_define?
        File.directory?('test')
      end

      def update_spec
        spec.files += Rake::FileList['test/**/*']
      end
    end

  end
end
