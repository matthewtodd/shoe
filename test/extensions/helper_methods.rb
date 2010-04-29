require 'open3'
require 'pathname'

module Shoe
  module TestExtensions

    module HelperMethods
      attr_reader :stdout, :stderr

      def system(*args)
        stdin, stdout, stderr = Open3.popen3(*args)
        stdin.close
        @stdout = stdout.read
        @stderr = stderr.read
      end

      def find(string)
        root = Pathname.new(string)
        root.enum_for(:find).
               select { |path| path.file? }.
              collect { |path| path.relative_path_from(root).to_s }
      end

      def write_file(path, contents)
        path = Pathname.new(path)
        path.parent.mkpath
        path.open('w') { |stream| stream.write(contents) }
      end

      def in_project(name)
        Dir.mkdir(name)
        Dir.chdir(name)
      end

      def with_fake_rubygems_server(&block)
        FakeRubygemsServer.start(&block)
      end

      def assert_file(path)
        assert Pathname.new(path).exist?, "#{path} does not exist."
      end

      def assert_find(path, expected)
        assert_equal expected.sort, find(path).sort
      end

      def assert_no_task(name)
        system 'rake --tasks'
        assert_no_match /\srake #{name}\s/, stdout
      end

      def assert_task(name)
        system 'rake --tasks'
        assert_match /\srake #{name}\s/, stdout
      end
    end

  end
end
