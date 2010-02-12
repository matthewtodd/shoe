require 'shoe'
require 'shoe/version'

Shoe.tie('shoe', Shoe::VERSION, 'Another take on hoe, jeweler & friends.') do |spec|
  spec.remove_development_dependency_on_shoe
  spec.requirements = ['git']
  spec.add_development_dependency 'bundler'
  spec.add_runtime_dependency 'cucumber'
  spec.add_runtime_dependency 'gemcutter'
  spec.add_runtime_dependency 'rake'
end
