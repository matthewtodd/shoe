module Shoe
  module Tasks
    autoload :Abstract,  'shoe/tasks/abstract'
    autoload :Clean,     'shoe/tasks/clean'
    autoload :Compile,   'shoe/tasks/compile'
    autoload :Cucumber,  'shoe/tasks/cucumber'
    autoload :Rdoc,      'shoe/tasks/rdoc'
    autoload :Ronn,      'shoe/tasks/ronn'
    autoload :Test,      'shoe/tasks/test'

    def self.define(spec)
      Clean.new(spec)
      Compile.new(spec)
      Cucumber.new(spec)
      Rdoc.new(spec)
      Ronn.new(spec)
      Test.new(spec)
    end
  end
end
