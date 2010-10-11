module DeclarativeTests
  def it(name, options={}, &block)
    Array(options[:require]).each do |lib|
      begin
        require lib
      rescue LoadError
        warn "#{lib} is not available. Skipping test \"#{name}\"."
        return
      end
    end

    define_method("test #{name}", &block)
  end
end

Shoe::TestCase.extend(DeclarativeTests)
