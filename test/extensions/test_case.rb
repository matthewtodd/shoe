module Shoe
  module TestExtensions

    module TestCase
      def isolate_environment
        include IsolatedEnvironment
      end

      def include_helper_methods
        include HelperMethods
      end

      def pending(name, options={}, &block)
        warn "WARN: Pending test \"#{name}\""
      end

      def test(name, options={}, &block)
        if !block_given?
          pending(name, options, &block)
          return
        end

        requires = Array(options[:require])

        requires.each do |lib|
          begin
            require lib
          rescue LoadError
            warn "WARN: #{lib} is not available.\n  Skipping test \"#{name}\""
            define_method('default_test', lambda {})
            return
          end
        end

        define_method("test #{name}", &block)
      end
    end

  end
end
