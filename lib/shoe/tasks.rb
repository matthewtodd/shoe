module Shoe
  module Tasks

    autoload :Abstract,  'shoe/tasks/abstract'
    autoload :Clean,     'shoe/tasks/clean'
    autoload :Compile,   'shoe/tasks/compile'
    autoload :Cucumber,  'shoe/tasks/cucumber'
    autoload :Man,       'shoe/tasks/man'
    autoload :Rdoc,      'shoe/tasks/rdoc'
    autoload :Release,   'shoe/tasks/release'
    autoload :Test,      'shoe/tasks/test'

    NAMES = %w(
      Clean
      Compile
      Cucumber
      Man
      Rdoc
      Release
      Test
    )

    def self.define(spec)
      NAMES.map { |name| const_get(name) }.
           each { |task| task.new(spec)  }
    end

  end
end
