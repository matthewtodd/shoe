begin
  require 'redgreen' if $stdout.tty?
rescue LoadError
  # Since we don't have hard gem dependencies for testing, folks can run `gem
  # check --test shoe` without installing anything else.
end
