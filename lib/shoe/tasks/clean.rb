module Shoe
  module Tasks

    # Defines <tt>`rake clean`</tt> to remove <tt>.gitignore</tt>d files and
    # directories.
    #
    # Uses something like <tt>`{git
    # clean}[http://www.kernel.org/pub/software/scm/git/docs/git-clean.html]
    # -fdX`</tt>, except preserves <tt>.bundle/</tt> and <tt>.rvmrc</tt>.
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
        desc <<-END.gsub(/^ */, '')
          Remove ignored files.
          Configure via your .gitignore file. Uses something like `git clean -fdX`,
          except preserves .bundle/ and .rvmrc.
        END

        task :clean do
          rm_r ignored_files - preserved_files
        end
      end

      private

      def ignored_files
        `git ls-files -z --exclude-standard --ignored --others --directory`.split("\0")
      end

      def preserved_files
        %w( .bundle/ .rvmrc )
      end
    end

  end
end
