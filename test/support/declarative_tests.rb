module DeclarativeTests
  def skip(name, options={}, &block)
    warn "Skipping test \"#{name}\""
  end

  def test(name, options={}, &block)
    Array(options[:require]).each do |lib|
      begin
        require lib
      rescue LoadError
        skip(name)
        return
      end
    end

    define_method("test #{name}", &block)
  end
end

Shoe::TestCase.extend(DeclarativeTests)
