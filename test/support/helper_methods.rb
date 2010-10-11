require 'pathname'

module HelperMethods
  SHOE_PATH = File.expand_path('../../..', __FILE__)

  def configure_project_for_shoe
    prepend_file 'Gemfile',  "path '#{SHOE_PATH}'"
    add_development_dependency 'shoe'
    append_file  'Rakefile', <<-END.gsub(/^ */, '')
      # need bundler setup only because shoe's not installed
      Bundler.setup(:default, :development)
      require 'shoe'
      Shoe.install_tasks
    END
  end

  def gemspec
    Dir['*.gemspec'].first
  end

  def add_to_gemspec(contents)
    inject_into_file(gemspec, contents, :before => /en.\s*\z/)
  end

  def add_development_dependency(name)
    add_to_gemspec("s.add_development_dependency('#{name}')")
  end

  def mask_todos_in_gemspec
    gsub_file(gemspec, /TODO: Write [ \w]*/, 'Masked')
  end
end

Shoe::TestCase.send(:include, HelperMethods)
