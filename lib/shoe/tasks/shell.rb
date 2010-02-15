module Shoe
  module Tasks

    # TODO can remove irb args -- and thus this task altogether! -- if we
    # assume bundler
    class Shell < AbstractTask
      def define
        desc 'Run an irb console'
        task :shell do
          exec 'irb', '-Ilib', "-r#{spec.name}"
        end
      end

      def should_define?
        File.file?("lib/#{spec.name}.rb")
      end
    end

  end
end
