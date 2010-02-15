module Shoe
  module Tasks

    class Resources < AbstractTask
      def update_spec
        spec.files += Rake::FileList['resources/**/*']
      end
    end

  end
end
