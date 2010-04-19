module Shoe
  module Tasks

    # Defines <tt>`rake release`</tt> to release your gem.
    #
    # To release is to: commit, tag, optionally push (with tags), and then
    # build and push your gem.
    #
    # This task is enabled under very specific circumstances, to safeguard
    # against accidental releases:
    # 1. Your <tt>version[http://docs.rubygems.org/read/chapter/20#version]</tt> is greater than <tt>0.0.0</tt>.
    # 2. There is no existing git tag <tt>"v#{version}"</tt>.
    # 3. You are currently on the <tt>master</tt> branch.
    #
    # To configure, adjust the
    # <tt>version[http://docs.rubygems.org/read/chapter/20#version]</tt> in
    # your gemspec.
    #
    # = Semantic Versioning
    #
    # Shoe helps you follow the Tagging Specification of {Semantic
    # Versioning}[http://semver.org] by tagging your releases as
    # <tt>"v#{version}"</tt>, prefixing a <tt>"v"</tt> before the version
    # number.
    #
    # Shoe additionally complains if you haven't yet created a <tt>semver</tt>
    # tag to denote your compliance.
    class Release < Abstract
      def active?
        spec.has_version_greater_than?('0.0.0') &&
          there_is_no_tag_for(version_tag(spec.version)) &&
          we_are_on_the_master_branch
      end

      def define
        desc "Release #{spec.full_name}"
        task :release do
          sh "git commit -a -m 'Release #{spec.version}'"
          sh "git tag #{version_tag(spec.version)}"

          if there_is_no_tag_for('semver')
            warn 'semantic versioning',
              "It seems you don't yet have a 'semver' tag.",
              'Please read more about the emerging consensus around semantic versioning:',
              'http://semver.org'
          end

          if there_is_a_remote_called('origin')
            sh 'git push origin master'
            sh 'git push --tags origin'
          end

          sh "gem build #{spec.name}.gemspec"
          sh "gem push #{spec.file_name}"
        end
      end

      private

      def there_is_a_remote_called(name)
        `git remote`.to_a.include?("#{name}\n")
      end

      def there_is_no_tag_for(tag)
        !`git tag`.to_a.include?("#{tag}\n")
      end

      def version_tag(version)
        "v#{spec.version}"
      end

      def we_are_on_the_master_branch
        `git symbolic-ref HEAD`.strip == 'refs/heads/master'
      end
    end

  end
end
