require 'erb'
require 'optparse'
require 'pathname'

module Shoe
  class Generator
    def initialize
      @options = OptionParser.new do |opts|
        opts.banner  = "Usage: #{File.basename($0)} [path]"
        opts.version = Shoe::VERSION
      end

      @root = Pathname.pwd
    end

    def run(argv)
      begin
        @options.order(argv) { |root| @root = Pathname.new(root) }
      rescue OptionParser::ParseError
        @options.abort($!)
      end

      path('README.rdoc').install template('readme.erb')
      path('Rakefile').install    template('rakefile.erb')
      path(module_path).install   template('module.erb')
      path(gemspec_path).install  template('gemspec.erb')
    end

    private

    def project_name
      @root.expand_path.basename.to_s
    end

    def project_module
      project_name.capitalize.gsub(/_(\w)/) { $1.upcase }
    end

    def project_version
      '0.0.0'
    end

    def module_path
      "lib/#{project_name}.rb"
    end

    def gemspec_path
      "#{project_name}.gemspec"
    end

    def template(name)
      ERB.new(template_contents(name)).result(binding)
    end

    def template_contents(name)
      Shoe.datadir.join('templates', name).read
    end

    def path(name)
      path = @root.join(name)
      path.dirname.mkpath
      path.extend(PathExtensions)
    end

    module PathExtensions #:nodoc:
      def install(contents)
        if exist?
          $stderr.puts "#{to_s} exists. Not clobbering."
        else
          open('w') { |file| file.write(contents) }
        end
      end
    end
  end
end
