require 'pathname'

module GemspecManipulation
  def add_development_dependency(name)
    add_to_gemspec("s.add_development_dependency('#{name}')")
  end

  def add_to_gemspec(contents)
    # don't say "end" to avoid confusing vim's formatter
    inject_into_file(gemspec, contents, :before => /en.\s*\z/)
  end

  def mask_gemspec_todos
    gsub_file(gemspec, /TODO: Write [ \w]*/, 'Masked')
  end

  private

  def gemspec
    Dir['*.gemspec'].first
  end
end

Shoe::TestCase.send(:include, GemspecManipulation)
