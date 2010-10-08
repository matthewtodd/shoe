$:.unshift File.expand_path('../lib', __FILE__)
require 'shoe/version'

Gem::Specification.new do |spec|
  spec.name    = 'shoe'
  spec.version = Shoe::VERSION

  spec.summary = 'An ecosystem-friendly library of Rake tasks for your gem.'
  spec.description = <<-END.gsub(/^ */, '')
    #{spec.summary}

    Shoe assumes you could be using any number of other tools -- bundler,
    cucumber, git, rip, rubygems -- and so leans hard on them for the things
    they do well, relegating command-line rake to mere syntactic sugar.
  END

  spec.author = 'Matthew Todd'
  spec.email  = 'matthew.todd@gmail.com'
  spec.homepage = 'http://github.com/matthewtodd/shoe'

  spec.requirements = ['git']
  spec.required_rubygems_version = '>= 1.3.6'
  spec.add_runtime_dependency 'rake', '~> 0.8.7'
  spec.add_runtime_dependency 'optparse-defaults', '~> 0.1.0'
  spec.add_development_dependency 'bundler',  '~> 1.0.0'
  spec.add_development_dependency 'cucumber', '~> 0.6.4'
  spec.add_development_dependency 'redgreen', '~> 1.2.2'
  spec.add_development_dependency 'ronn',     '~> 0.5'

  spec.files            = Dir['**/*.rdoc', 'bin/*', 'data/**/*', 'ext/**/*.{rb,c}', 'lib/**/*.rb', 'man/**/*', 'test/**/*.rb']
  spec.executables      = Dir['bin/*'].map &File.method(:basename)
  spec.extensions       = Dir['ext/**/extconf.rb']
  spec.extra_rdoc_files = Dir['**/*.rdoc', 'ext/**/*.c']
  spec.test_files       = Dir['test/**/*_test.rb']

  spec.rdoc_options     = %W(
    --main README.rdoc
    --title #{spec.full_name}
    --inline-source
    --webcvs http://github.com/matthewtodd/shoe/blob/v#{spec.version}/
  )
end
