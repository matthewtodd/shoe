module Shoe
  module Extensions

    module Pathname
      def install(contents, mode)
        if exist?
          warn "#{to_s} exists. Not clobbering."
        else
          open('w') { |file| file.write(contents) }
          chmod(mode)
        end
      end
    end

  end
end
