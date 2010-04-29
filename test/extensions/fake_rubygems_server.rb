require 'logger'
require 'rubygems/format'
require 'stringio'
require 'webrick'

module Shoe
  module TestExtensions

    class FakeRubygemsServer
      def self.start(&block)
        new.start(&block)
      end

      def initialize(host='127.0.0.1', port=48484)
        @initial_rubygems_host = ENV['RUBYGEMS_HOST']
        @fake_rubygems_host    = "http://#{host}:#{port}"

        @message_bus = Queue.new
        @webrick = WEBrick::HTTPServer.new(
                     # Ruby is super slow to create the underlying Socket if
                     # (my ISP's upstream connection is flakey? and) we don't
                     # specify a BindAddress.
                     :BindAddress   => host,
                     :Port          => port,
                     :Logger        => Logger.new(nil),
                     :AccessLog     => [],
                     :StartCallback => lambda { @message_bus.push(:ready) }
                   )

        @webrick.mount_proc('/api/v1/gems') do |req, res|
          @uploaded_gem = req.body
          @uploaded_gem.extend(GemEntries)
        end
      end

      def start(&block)
        ENV['RUBYGEMS_HOST'] = @fake_rubygems_host
        thread = Thread.new { @webrick.start }
        @message_bus.pop
        block.call
        return @uploaded_gem
      ensure
        ENV['RUBYGEMS_HOST'] = @initial_rubygems_host
        @webrick.shutdown
        thread.join
      end

      private

      module GemEntries
        def contents
          package.file_entries.map { |entry| entry.first['path'] }
        end

        def package
          Gem::Format::from_io(StringIO.new(self))
        end
      end
    end

  end
end
