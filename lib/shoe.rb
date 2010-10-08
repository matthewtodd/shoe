require 'shoe/version'

require 'pathname'
require 'rbconfig'
require 'rbconfig/datadir'

module Shoe
  autoload :Browser,    'shoe/browser'
  autoload :Extensions, 'shoe/extensions'
  autoload :Generator,  'shoe/generator'
  autoload :Tasks,      'shoe/tasks'

  def self.datadir
    @@datadir ||= begin
      datadir = RbConfig.datadir('shoe')
      if !File.exist?(datadir)
        warn "WARN: #{datadir} does not exist.\n  Trying again with relative data directory..."
        datadir = File.expand_path('../../data/shoe', __FILE__)
      end
      Pathname.new(datadir)
    end
  end
end
