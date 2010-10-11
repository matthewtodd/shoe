require 'shoe/version'

module Shoe
  autoload :Extensions, 'shoe/extensions'
  autoload :Tasks,      'shoe/tasks'

  class << self
    def browse(url)
      system(browser, url)
    end

    def install_tasks(name='*')
      Tasks.define Dir["#{name}.gemspec"].first
    end

    private

    # stolen from hub
    def browser
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

    def command?(name)
      `which #{name} 2>/dev/null`
      $?.success?
    end
  end
end
