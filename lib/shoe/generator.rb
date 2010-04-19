require 'erb'
require 'optparse'
require 'pathname'

module Shoe
  class Generator
    def initialize
      @defaults = %w(--no-application .)

      @options  = OptionParser.new do |opts|
        opts.banner  = "Usage: #{File.basename($0)} [options] [path]"
        opts.version = Shoe::VERSION

        opts.separator ''
        opts.on('-a', '--[no-]application', 'Generate a command-line application.') do |application|
          @application = application
        end

        opts.separator ''
        opts.separator 'Defaults:'
        opts.separator opts.summary_indent + @defaults.join(' ')
      end
    end

    def run(argv)
      begin
        @options.order(@defaults.concat(argv)) { |path| @path = Pathname.new(path) }
      rescue OptionParser::ParseError
        @options.abort($!)
      end

      path('README.rdoc').install template('readme.erb')
      path('Rakefile').install    template('rakefile.erb')
      path(gemspec_path).install  template('gemspec.erb')
      path(module_path).install   template('module.erb')

      if application?
        path(executable_path).install  template('executable.erb'), 0755
        path(application_path).install template('application.erb')
      end
    end

    private

    def project_name
      @path.expand_path.basename.to_s
    end

    def project_module
      project_name.capitalize.gsub(/_(\w)/) { $1.upcase }
    end

    def project_version
      '0.0.0'
    end

    def application?
      @application
    end

    def application_path
      "lib/#{project_name}/application.rb"
    end

    def executable_path
      "bin/#{project_name}"
    end

    def gemspec_path
      "#{project_name}.gemspec"
    end

    def module_path
      "lib/#{project_name}.rb"
    end

    def template(name)
      ERB.new(template_contents(name), nil, '<>').result(binding)
    end

    def template_contents(name)
      Shoe.datadir.join('templates', name).read
    end

    def path(name)
      path = @path.join(name)
      path.dirname.mkpath
      path.extend(PathExtensions)
    end

    module PathExtensions #:nodoc:
      def install(contents, mode=0644)
        if exist?
          $stderr.puts "#{to_s} exists. Not clobbering."
        else
          open('w') { |file| file.write(contents) }
          chmod(mode)
        end
      end
    end
  end
end
