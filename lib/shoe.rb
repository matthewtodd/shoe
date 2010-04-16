require 'pathname'
require 'rbconfig'
require 'rbconfig/datadir'

module Shoe
  autoload :Generator, 'shoe/generator'
  autoload :Tasks,     'shoe/tasks'

  def self.datadir
    Pathname.new RbConfig.datadir('shoe')
  end
end
