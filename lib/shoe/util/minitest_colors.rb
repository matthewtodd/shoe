require 'delegate'

module Shoe
  module Util

    class MiniTestColors < DelegateClass(IO)
      RED    = 31
      GREEN  = 32
      YELLOW = 33
      CYAN   = 36

      def print(object)
        case object
        when '.'
          super color(GREEN, object)
        when 'F'
          super color(RED, object)
        when 'E'
          super color(YELLOW, object)
        when 'S'
          super color(CYAN, object)
        else
          super
        end
      end

      STATUS = /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors, \d+ skips/

      def puts(*objects)
        if objects.size == 1
          string = objects.first

          string.gsub!(STATUS) do |match|
            failures, errors = $1.to_i, $2.to_i
            if failures + errors == 0
              color(GREEN, match)
            else
              color(RED, match)
            end
          end

          string.gsub!(/\bFailure:/) { |s| color(RED, s) }
          string.gsub!(/\bError:/)   { |s| color(YELLOW, s) }
          string.gsub!(/\bSkipped:/) { |s| color(CYAN, s) }
        end

        super
      end

      private

      def color(code, string)
        "\e[#{code}m#{string}\e[0m"
      end
    end

  end
end

MiniTest::Unit.output = Shoe::Util::MiniTestColors.new($stdout)
