# Shoe defines some handy Rake tasks for your project, all built around your
# Gem::Specification.
#
# Here's how you use it in your Rakefile:
#
#  require 'shoe'
#  Shoe.tie('myproject', '0.1.0', "This is my project, and it's awesome!") do |spec|
#    # do whatever you want with the Gem::Specification here, for example:
#    # spec.add_runtime_dependency 'dnssd'
#  end
#
# Shoe comes with an executable named "shoe" that will generate a Rakefile like
# this (but slightly fancier) for you.
module Shoe
  autoload :Project, 'shoe/project'

  # Here's where you start. In your Rakefile, you'll probably just call
  # Shoe.tie, then add any dependencies in the block.
  def self.tie(name, version, summary)
    project = Project.new(name, version, summary)
    yield project.spec if block_given?
    project.define_tasks
  end
end
