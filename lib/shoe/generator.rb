require 'erb'
require 'pathname'

module Shoe
  class Generator
    def initialize
      @root          = Pathname.pwd.expand_path
      @template_path = Pathname.new(__FILE__).dirname.join('templates')
    end

    def run
      path('README.rdoc').install template('readme.erb')
      path('Gemfile').update      template('gemfile.erb')
      path('Rakefile').install    template('rakefile.erb')
      path(version_path).install  template('version.erb')
      path(gemspec_path).install  template('gemspec.erb')
    end

    private

    def project_name
      @root.basename.to_s
    end

    def project_module
      project_name.capitalize.gsub(/_(\w)/) { $1.upcase }
    end

    def project_version
      '0.0.0'
    end

    def version_path
      "lib/#{project_name}/version.rb"
    end

    def gemspec_path
      "#{project_name}.gemspec"
    end

    def template(name)
      ERB.new(template_contents(name)).result(binding)
    end

    def template_contents(name)
      @template_path.join(name).read
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
          write(contents, 'w')
        end
      end

      def update(contents)
        if exist?
          write(contents, 'a')
        else
          $stderr.puts "#{to_s} does not exist. Not updating."
        end
      end

      private

      def write(contents, mode)
        open(mode) { |file| file.write(contents) }
      end
    end
  end
end
