#!/usr/bin/env ruby

require 'erb'
require 'pathname'

class Shoe
  class CLI
    class << self
      def run
        new.run
      end
    end

    attr_reader :root
    attr_reader :spec
    attr_reader :template_path

    def initialize
      @root = Pathname.pwd.expand_path

      @spec = Gem::Specification.new do |spec|
        spec.name = root.basename.to_s
        spec.version = '0.0.0'
      end

      @template_path = Pathname.new(__FILE__).dirname.join('templates')
    end

    def run
      path('Gemfile').update template('gemfile.erb')

      path('README.rdoc').install template('readme.erb')
      path('Rakefile').install    template('rakefile.erb')
      path(version_path).install  template('version.erb')
      path(gemspec_path).install  spec.to_ruby
    end

    private

    def project
      spec.name
    end

    def project_class
      project.capitalize.gsub(/_(\w)/) { $1.upcase }
    end

    def project_version
      spec.version
    end

    def version_path
      "lib/#{project}/version.rb"
    end

    def gemspec_path
      "#{project}.gemspec"
    end

    def template(name)
      ERB.new(template_contents(name)).result(binding)
    end

    def template_contents(name)
      template_path.join(name).read
    end

    def path(name)
      path = root.join(name)
      path.dirname.mkpath
      path.extend(PathExtensions)
    end

    module PathExtensions
      def install(contents)
        if exist?
          $stderr.puts "#{to_s} exists. Not clobbering."
        else
          write(contents, 'w')
        end
      end

      def update(contents)
        write(contents, 'a')
      end

      private

      def write(contents, mode)
        open(mode) { |file| file.write(contents) }
      end
    end
  end
end
