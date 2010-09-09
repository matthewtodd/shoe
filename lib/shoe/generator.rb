require 'erb'
require 'optparse/defaults'
require 'pathname'

module Shoe
  class Generator
    def initialize
      @options = {}
      @parser  = OptionParser.with_defaults do |opts|
        opts.banner   = "Usage: #{File.basename($0)} [-adehtv] [path]"
        opts.defaults = %w(--no-application --no-data --no-extension --test-unit .)
        opts.version  = Shoe::VERSION

        opts.on('-a', '--[no-]application', 'Generate a command-line application.') do |application|
          @options[:application] = application
        end

        opts.on('-d', '--[no-]data', 'Generate a data directory.') do |data|
          @options[:data] = data
        end

        opts.on('-e', '--[no-]extension', 'Generate a C extension.') do |extension|
          @options[:extension] = extension
        end

        opts.on('-t', '--[no-]test-unit', 'Generate Test::Unit tests.') do |test_unit|
          @options[:test_unit] = test_unit
        end
      end
    end

    def run(arguments)
      @parser.order(arguments) { |path| @project = Project.new(path, @options) }

      @project.generate
    end

    private


    class Project
      def initialize(path, options)
        @path    = Pathname.new(path)
        @options = options
      end

      def generate
        install('gitignore.erb', '.gitignore')
        install('readme.erb',    'README.rdoc')
        install('rakefile.erb',  'Rakefile')
        install('gemspec.erb',   "#{name}.gemspec")
        install('module.erb',    "lib/#{name}.rb")
        install('version.erb',   "lib/#{name}/version.rb")
        install('manpage_3.erb', "man/#{name}.3.ronn")

        if application?
          install('executable.erb',  "bin/#{name}", 0755)
          install('application.erb', "lib/#{name}/application.rb")
          install('manpage_1.erb',   "man/#{name}.1.ronn")
        end

        if data?
          install('gitkeep.erb', "data/#{name}/.gitkeep")
        end

        if extension?
          install('extconf.erb',   "ext/#{name}/extconf.rb")
          install('extension.erb', "ext/#{name}/#{extension_name}.c")
        end

        if test_unit?
          install('test_helper.erb', "test/helper.rb")
          install('module_test.rb',  "test/#{name}_test.rb")
        end
      end

      private

      def install(template, path, mode=0644)
        installable_path(path).install(contents(template), mode)
      end

      def application?
        @options[:application]
      end

      def data?
        @options[:data]
      end

      def extension?
        @options[:extension]
      end

      def test_unit?
        @options[:test_unit]
      end

      def name
        @path.expand_path.basename.to_s
      end

      def module_name
        name.capitalize.gsub(/_(\w)/) { $1.upcase }
      end

      def version
        '0.0.0'
      end

      def extension_name
        'extension'
      end

      def extension_module_name
        extension_name.capitalize.gsub(/_(\w)/) { $1.upcase }
      end

      def installable_path(name)
        path = @path.join(name)
        path.dirname.mkpath
        path.extend(Extensions::Pathname)
      end

      def contents(template)
        Template.new(template).evaluate(binding)
      end
    end

    class Template
      def initialize(name)
        @name = name
      end

      def evaluate(binding)
        ERB.new(contents, nil, '<>').result(binding)
      end

      private

      def contents
        Shoe.datadir.join('templates', @name).read
      end
    end
  end
end
