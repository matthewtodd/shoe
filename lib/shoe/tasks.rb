module Shoe
  module Tasks

    autoload :Abstract,  'shoe/tasks/abstract'
    autoload :Clean,     'shoe/tasks/clean'
    autoload :Compile,   'shoe/tasks/compile'
    autoload :Cucumber,  'shoe/tasks/cucumber'
    autoload :Rdoc,      'shoe/tasks/rdoc'
    autoload :Release,   'shoe/tasks/release'
    autoload :Test,      'shoe/tasks/test'

    LOAD_ORDER = %w(
      Clean
      Rdoc
      Release
      Test
      Cucumber
      Compile
    )

    def self.define(spec_path)
      spec = Gem::Specification.load(spec_path)
      each do |task|
        task.define spec
      end
    end

    def self.each
      LOAD_ORDER.map { |name| const_get name }.
                each { |task| yield task }
    end

  end
end
