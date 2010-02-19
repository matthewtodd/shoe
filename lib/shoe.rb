module Shoe
  autoload :Project, 'shoe/project'
  autoload :Tasks,   'shoe/tasks'

  def self.tie(name, version, summary)
    project = Project.new(name, version, summary)
    yield project.spec if block_given?
    project.define_tasks
  end
end
