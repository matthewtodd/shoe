module Shoe

  module Color
    extend self

    def red(string)
      color(31, string)
    end

    def yellow(string)
      color(33, string)
    end

    def green(string)
      color(32, string)
    end

    private

    def color(color, string)
      if color?
        "\e[#{color}m#{string}\e[0m"
      else
        string
      end
    end

    def color?
      env('CLICOLOR_FORCE') || (env('CLICOLOR') && STDOUT.tty?)
    end

    def env(name)
      ENV[name].to_s =~ /^(y|on|1)/i
    end
  end

end
