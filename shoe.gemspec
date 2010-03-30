# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shoe}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Todd"]
  s.date = %q{2010-03-30}
  s.default_executable = %q{shoe}
  s.email = %q{matthew.todd@gmail.com}
  s.executables = ["shoe"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Rakefile", "lib/shoe", "lib/shoe/cli.rb", "lib/shoe/project.rb", "lib/shoe/tasks", "lib/shoe/tasks/bin.rb", "lib/shoe/tasks/clean.rb", "lib/shoe/tasks/compile.rb", "lib/shoe/tasks/cucumber.rb", "lib/shoe/tasks/gemspec.rb", "lib/shoe/tasks/rdoc.rb", "lib/shoe/tasks/release.rb", "lib/shoe/tasks/resources.rb", "lib/shoe/tasks/shell.rb", "lib/shoe/tasks/shoulda.rb", "lib/shoe/tasks/test.rb", "lib/shoe/tasks.rb", "lib/shoe/templates", "lib/shoe/templates/gemfile.erb", "lib/shoe/templates/rakefile.erb", "lib/shoe/templates/readme.erb", "lib/shoe/templates/version.erb", "lib/shoe/version.rb", "lib/shoe.rb", "bin/shoe", "README.rdoc", "shoe.gemspec", "features/cucumber.feature", "features/getting_started.feature", "features/release.feature", "features/step_definitions", "features/step_definitions/shoe_steps.rb", "features/support", "features/support/env.rb"]
  s.rdoc_options = ["--main", "README.rdoc", "--title", "shoe-0.3.0", "--inline-source"]
  s.require_paths = ["lib"]
  s.requirements = ["git"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Another take on hoe, jeweler & friends.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
