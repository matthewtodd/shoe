module Shoe
  module Extensions
    autoload :DocManager,    'shoe/extensions/doc_manager'
    autoload :OptionParser,  'shoe/extensions/option_parser'
    autoload :Pathname,      'shoe/extensions/pathname'
    autoload :SourceIndex,   'shoe/extensions/source_index'
    autoload :Specification, 'shoe/extensions/specification'
    autoload :TestRunner,    'shoe/extensions/test_runner'
    autoload :Validator,     'shoe/extensions/validator'
  end
end
