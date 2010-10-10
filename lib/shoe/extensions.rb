module Shoe
  module Extensions
    autoload :DocManager,    'shoe/extensions/doc_manager'
    autoload :SourceIndex,   'shoe/extensions/source_index'
    autoload :Specification, 'shoe/extensions/specification'
    autoload :TestRunner,    'shoe/extensions/test_runner'
    autoload :Validator,     'shoe/extensions/validator'
  end
end
