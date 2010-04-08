module Shoe
  module Tasks

    # Defines <tt>`rake clean`</tt> to remove <tt>.gitignore</tt>d files and
    # directories.
    #
    # Uses <tt>`{git clean}[http://www.kernel.org/pub/software/scm/git/docs/git-clean.html] -fdX`</tt>.
    #
    # To enable, version your project with git[http://git-scm.com].
    #
    # To configure, edit your
    # <tt>{.gitignore}[http://www.kernel.org/pub/software/scm/git/docs/gitignore.html]</tt>.
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
