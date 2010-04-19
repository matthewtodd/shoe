module Shoe
  module Extensions

    module OptionParser
      attr_accessor :defaults

      def order(*args, &block)
        begin
          super(defaults.dup.concat(*args), &block)
        rescue ::OptionParser::ParseError
          abort($!)
        end
      end

      def summarize(*args, &block)
        return <<-END.gsub(/^ {10}/, '')
          #{super}
          Defaults:
          #{summary_indent}#{defaults.join(' ')}
        END
      end
    end

  end
end
