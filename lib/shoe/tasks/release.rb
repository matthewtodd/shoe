module Shoe
  module Tasks

    class Release < Abstract
      def active?
        spec.extend(VersionExtensions)

        spec.has_version_greater_than?('0.0.0') &&
          there_is_no_tag_for(version_tag(spec.version)) &&
          we_are_on_the_master_branch
      end

      def define
        desc "Release #{spec.full_name}"
        task :release do
          sh "git add #{spec.name}.gemspec"
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

      module VersionExtensions
        def has_version_greater_than?(string)
          version > Gem::Version.new(string)
        end
      end

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
