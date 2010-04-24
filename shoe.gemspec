$:.unshift File.expand_path('../lib', __FILE__)
require 'shoe'

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
  spec.add_runtime_dependency 'rake'
  spec.add_runtime_dependency 'launchy'
  spec.add_development_dependency 'redgreen'
  spec.add_development_dependency 'ronn'

  def spec.git_files(glob=nil)
    `git ls-files -z --cached --other --exclude-standard #{glob}`.split("\0")
  end

  spec.files       = spec.git_files
  spec.executables = spec.git_files('bin/*').map &File.method(:basename)
  spec.extensions  = spec.git_files('ext/**/extconf.rb')
  spec.test_files  = spec.git_files('test/{,**/}*_test.rb')

  spec.extra_rdoc_files = spec.git_files('{,**/}*.rdoc')
  spec.rdoc_options     = %W(
    --main README.rdoc
    --title #{spec.full_name}
    --inline-source
    --webcvs http://github.com/matthewtodd/shoe/blob/v#{spec.version}/
  )
end
