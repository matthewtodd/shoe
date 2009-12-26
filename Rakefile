$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'shoe'

Shoe.tie('shoe', '0.1.13', 'Another take on hoe, jeweler & friends.') do |spec|
  spec.remove_development_dependency_on_shoe
  spec.requirements = ['git']
  spec.add_runtime_dependency 'cucumber'
  spec.add_runtime_dependency 'gemcutter'
  spec.add_runtime_dependency 'rake'
end
