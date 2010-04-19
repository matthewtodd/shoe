module Shoe
  module Extensions

    module Logger
      def self.extended(logger)
        logger.formatter = Formatter.new
      end

      class Formatter
        WIDTH = 72

        def call(severity, time, name, message)
          color(severity, format(message))
        end

        private

        def color(severity, string)
          case severity
          when 'WARN'
            "\e[33m#{string}\e[0m"
          else
            string
          end
        end

        def format(message)
          case message
          when String
            "#{message}\n"
          when Array
            subject    = message.shift
            paragraphs = message

            result = []
            result << '-' * WIDTH
            result << "#{subject} message from shoe".upcase
            paragraphs.each do |paragraph|
              result << ''
              result << wrap(paragraph)
            end
            result << '-' * WIDTH
            result << ''
            result.join("\n")
          end
        end

        def wrap(string)
          string.gsub(/(.{1,#{WIDTH}})( +|$\n?)|(.{1,#{WIDTH}})/, "\\1\\3\n").chomp
        end
      end
    end

  end
end
