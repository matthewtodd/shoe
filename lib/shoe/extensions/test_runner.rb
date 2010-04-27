module Shoe
  module Extensions

    module TestRunner
      # Conforms the normal TestRunner interface to the slightly different form
      # called by Gem::Validator.
      def run(*args)
        new(args.first, Test::Unit::UI::NORMAL).extend(InstanceMethods).start
      end

      # TOTALLY ganked from redgreen.
      module InstanceMethods
        def output(something, level=Test::Unit::UI::NORMAL)
          something = case something.to_s
                      when /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors/
                        if $1.to_i == 0 && $2.to_i == 0
                          Shoe::Color.green(something)
                        else
                          Shoe::Color.red(something)
                        end
                      when /Failure/ then something.gsub('Failure', Shoe::Color.red('Failure'))
                      when /Error/   then something.gsub('Error',   Shoe::Color.yellow('Error'))
                      else something
                      end
          super(something, level)
        end

        def output_single(something, level=Test::Unit::UI::NORMAL)
          something = case something
                      when '.' then Shoe::Color.green('.')
                      when 'F' then Shoe::Color.red('F')
                      when 'E' then Shoe::Color.yellow('E')
                      else something
                      end
          super(something, level)
        end
      end
    end

  end
end
