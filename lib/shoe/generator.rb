require 'erb'
require 'optparse'
require 'pathname'

module Shoe
  class Generator
    def initialize
      @options = {}
      @parser  = OptionParser.new do |opts|
        opts.extend(Extensions::OptionParser)

        opts.banner   = "Usage: #{File.basename($0)} [options] [path]"
        opts.defaults = %w(--no-application .)
        opts.version  = Shoe::VERSION

        opts.on('-a', '--[no-]application', 'Generate a command-line application.') do |application|
          @options[:application] = application
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
        install('readme.erb',   'README.rdoc')
        install('rakefile.erb', 'Rakefile')
        install('gemspec.erb',  "#{name}.gemspec")
        install('module.erb',   "lib/#{name}.rb")

        if application?
          install('executable.erb',  "bin/#{name}", 0755)
          install('application.erb', "lib/#{name}/application.rb")
        end
      end

      def install(template, path, mode=0644)
        installable_path(path).install(contents(template), mode)
      end

      private

      def name
        @path.expand_path.basename.to_s
      end

      def module_name
        name.capitalize.gsub(/_(\w)/) { $1.upcase }
      end

      def version
        '0.0.0'
      end

      def application?
        @options[:application]
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
