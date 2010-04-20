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
    @@datadir ||= begin
      datadir = RbConfig.datadir('shoe')
      if !File.exist?(datadir)
        warn "#{datadir} does not exist. Trying again with data directory relative to __FILE__."
        datadir = File.expand_path('../../data/shoe', __FILE__)
      end
      Pathname.new(datadir)
    end
  end

  def self.logger
    @@logger ||= Logger.new(STDERR).extend(Extensions::Logger)
  end
end
