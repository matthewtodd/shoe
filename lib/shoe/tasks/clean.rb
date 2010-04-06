module Shoe
  module Tasks

    class Clean < Abstract
      def active?
        File.directory?('.git')
      end

      def define
        desc 'Remove ignored files'
        task :clean do
          sh 'git clean -fdX'
        end
      end
    end

  end
end
