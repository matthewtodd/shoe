module Shoe
  module Tasks

    class Clean < AbstractTask
      def define
        desc 'Remove ignored files'
        task :clean do
          sh 'git clean -fdX'
        end
      end

      def should_define?
        File.directory?('.git')
      end
    end

  end
end
