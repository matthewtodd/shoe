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
      install(template('readme.erb'),   path('README.rdoc'))
      install(template('rakefile.erb'), path('Rakefile'))
      install(template('version.erb'),  path("lib/#{project}/version.rb"))
      install(spec.to_ruby,             path("#{project}.gemspec"))
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

    def install(contents, path)
      if path.exist?
        $stderr.puts "#{path} exists. Not clobbering."
      else
        path.open('w') do |stream|
          stream.write(contents)
        end
      end
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
      path
    end
  end
end
