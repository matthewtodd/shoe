require 'rubygems/validator'

module Shoe
  module Tasks

    # Defines <tt>`rake test`</tt> to run your tests.
    #
    # Uses
    # <tt>{Gem::Validator}[http://rubygems.rubyforge.org/rubygems-update/Gem/Validator.html]</tt>,
    # so tests are run locally just as they will be with <tt>`{gem
    # check}[http://docs.rubygems.org/read/chapter/10#page30] --test
    # your_project`</tt>.
    #
    # To enable and configure, edit the
    # <tt>test_files[http://docs.rubygems.org/read/chapter/20#test_files]</tt>
    # in your gemspec.
    #
    # = A Few Precautions
    #
    # * Using <tt>Gem::Validator</tt> means that only <tt>Test::Unit</tt> (all
    #   Rubies) and <tt>MiniTest::Unit</tt> (Ruby 1.9) tests will be run.
    #
    # * You'll need to <tt>Bundler.setup(:default, :development)</tt> in your
    #   <tt>Rakefile</tt> so that the <tt>Gem::Validator</tt> can find your
    #   code. (If you put this line in your <tt>test_helper</tt> instead,
    #   you'll break <tt>`gem check --test`</tt> for people who don't have
    #   Bundler installed.)
    #
    # * The <tt>test</tt> directory will not be in the <tt>$LOAD_PATH</tt>, so
    #   you'll have to <tt>require 'test/test_helper'</tt>.
    #
    # = Pretty Colors
    #
    # For Ruby 1.8, Shoe patches the <tt>Gem::Validator</tt> to play nicely with
    # {redgreen}[http://rubygems.org/gems/redgreen]</tt>.
    #
    # For Ruby 1.9, <tt>require 'shoe/util/minitest_colors'</tt> in your
    # <tt>test_helper</tt>.
    #
    class Test < Task
      def active?
        !spec.test_files.empty?
      end

      def define
        desc <<-END.gsub(/^ */, '')
          Run tests.
          Configure via the `test_files` field in #{spec.name}.gemspec.
        END

        task :test do
          Gem::Validator.extend(Extensions::Validator)
          Gem::Validator.new.unit_test(spec)
        end

        task :prepare

        task :test => :prepare

        task :default
        Rake.application[:default].prerequisites.unshift(Rake.application[:test])
      end
    end

  end
end
