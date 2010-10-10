require 'shoe/version'

module Shoe
  autoload :Browser,    'shoe/browser'
  autoload :Extensions, 'shoe/extensions'
  autoload :Tasks,      'shoe/tasks'

  def self.install_tasks(name='*')
    # totally stolen from Bundler::GemHelper.
    gemspecs = Dir["#{name}.gemspec"]
    raise "Unable to determine name from existing gemspec. Use 'gemname' in #install_tasks to manually set it." unless gemspecs.size == 1
    Tasks.define(gemspecs.first)
  end
end
