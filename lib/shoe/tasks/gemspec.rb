module Shoe
  module Tasks

    class Gemspec < AbstractTask
      def define
        desc 'Show latest gemspec contents'
        task :gemspec do
          puts spec.to_ruby
        end
      end
    end

  end
end
