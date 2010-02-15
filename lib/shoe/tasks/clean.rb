module Shoe
  module Tasks

    class Clean < AbstractTask
      def define_tasks
        desc 'Remove ignored files'
        task :clean do
          sh 'git clean -fdX'
        end
      end

      def should_define_tasks?
        File.directory?('.git')
      end
    end

  end
end
