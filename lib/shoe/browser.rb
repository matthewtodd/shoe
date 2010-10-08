module Shoe
  class Browser
    def self.open(url)
      new.open(url)
    end

    def open(url)
      system browser_launcher, url
    end

    private

    # This code *totally* stolen from Chris Wanstrath's most excellent hub.
    def command?(name)
      `which #{name} 2>/dev/null`
      $?.success?
    end

    def browser_launcher
      if ENV['BROWSER']
        ENV['BROWSER']
      elsif RUBY_PLATFORM.include?('darwin')
        'open'
      elsif command?("xdg-open")
        'xdg-open'
      elsif command?("cygstart")
        'cygstart'
      else
        abort 'Please set $BROWSER to a web launcher to use this command.'
      end
    end
  end
end

