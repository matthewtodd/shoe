module Shoe
  module Extensions

    module Pathname
      def install(contents, mode)
        if exist?
          warn "WARN: not clobbering existing #{to_s}"
        else
          open('w') { |file| file.write(contents) }
          chmod(mode)
        end
      end
    end

  end
end
