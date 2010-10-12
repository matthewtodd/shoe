# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'shoe/version'

Gem::Specification.new do |s|
  s.name        = 'shoe'
  s.version     = Shoe::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Matthew Todd']
  s.email       = ['matthew.todd@gmail.com']
  s.homepage    = 'http://github.com/matthewtodd/shoe'
  s.summary     = 'Configuration-free Rake tasks that read your gemspec.'
  s.description = "#{s.summary} These tasks re-use built-in Rubygems functionality so you can be confident you're shipping what you think you are."

  s.rubyforge_project = 'shoe'

  s.requirements = ['git']
  s.required_rubygems_version = '>= 1.3.6'
  s.add_runtime_dependency 'rake', '~> 0.8.7'
  s.add_development_dependency 'bundler',  '~> 1.0.0'
  s.add_development_dependency 'cucumber', '~> 0.6.4'
  s.add_development_dependency 'ronn',     '~> 0.5'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- test`.split("\n")
  s.extra_rdoc_files = `git ls-files -- {**/,}*.rdoc`.split("\n")
  s.require_paths    = ['lib']

  s.rdoc_options = %W(
    --main README.rdoc
    --title #{s.full_name}
    --inline-source
    --webcvs http://github.com/matthewtodd/shoe/blob/v#{s.version}/
  )
end
