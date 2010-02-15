module Shoe
  module Tasks

    class Bin < AbstractTask
      def update_spec
        spec.files       += Rake::FileList['bin/*']
        spec.executables += Rake::FileList['bin/*'].map do |path|
          File.basename(path)
        end
      end
    end

  end
end
