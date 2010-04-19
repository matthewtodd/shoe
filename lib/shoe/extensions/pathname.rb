module Shoe
  module Extensions

    module Pathname
      def install(contents, mode)
        if exist?
          Shoe.logger.warn "#{to_s} exists. Not clobbering."
        else
          open('w') { |file| file.write(contents) }
          chmod(mode)
        end
      end
    end

  end
end
