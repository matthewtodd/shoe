module DeclarativeTests
  def describe(name, &block)
    @context ||= []
    @context.push(name)
    block.call
    @context.pop
  end

  def requires(lib, &block)
    require lib
  rescue LoadError
    warn "#{lib} is not available. Skipping some tests."
  else
    block.call
  end

  def it(name, &block)
    describe(name) do
      define_method("test #{@context.join(' ')}", &block)
    end
  end
end

Shoe::TestCase.extend(DeclarativeTests)
