$:.unshift 'lib'
require 'shoe'

Shoe::Tasks.define('shoe.gemspec')

desc 'Generate man pages'
task :man do
  sh 'ronn --build --roff --html --organization="MATTHEW TODD" man/*.ronn'
end
