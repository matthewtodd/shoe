module Shoe
  module Tasks

    class Shoulda < AbstractTask
      def update_spec
        spec.files            += Rake::FileList['shoulda_macros/**/*']
        spec.extra_rdoc_files += Rake::FileList['shoulda_macros/**/*']
      end
    end

  end
end
