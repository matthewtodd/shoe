require 'pathname'
require 'rbconfig'
require 'rbconfig/datadir'

module Shoe
  VERSION = '0.5.1'

  autoload :Generator, 'shoe/generator'
  autoload :Tasks,     'shoe/tasks'

  def self.datadir
    Pathname.new RbConfig.datadir('shoe')
  end
end
