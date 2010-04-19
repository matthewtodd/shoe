require 'logger'
require 'pathname'
require 'rbconfig'
require 'rbconfig/datadir'

module Shoe
  VERSION = '0.5.1'

  autoload :Extensions, 'shoe/extensions'
  autoload :Generator,  'shoe/generator'
  autoload :Tasks,      'shoe/tasks'

  def self.datadir
    @@datadir ||= Pathname.new(RbConfig.datadir('shoe'))
  end

  def self.logger
    @@logger ||= Logger.new(STDERR)
  end
end
