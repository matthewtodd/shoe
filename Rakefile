$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'shoe'

Shoe.tie('shoe', '0.1.2', "You probably don't want to use Shoe.") do |spec|
  spec.remove_development_dependency_on_shoe
  spec.add_runtime_dependency 'cucumber'
  spec.add_runtime_dependency 'rake'
end
