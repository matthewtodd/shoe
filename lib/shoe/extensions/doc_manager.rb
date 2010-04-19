module Shoe
  module Extensions

    module DocManager
      def self.extended(manager)
        manager.instance_variable_set(:@doc_dir, Dir.pwd)
      end
    end

  end
end
