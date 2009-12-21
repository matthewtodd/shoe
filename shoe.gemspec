# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shoe}
  s.version = "0.1.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Todd"]
  s.date = %q{2009-12-21}
  s.default_executable = %q{shoe}
  s.email = %q{matthew.todd@gmail.com}
  s.executables = ["shoe"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Rakefile", "shoe.gemspec", "README.rdoc", "bin/shoe", "features/cucumber.feature", "features/getting_started.feature", "features/release.feature", "features/step_definitions", "features/step_definitions/shoe_steps.rb", "features/support", "features/support/env.rb", "lib/shoe.rb"]
  s.rdoc_options = ["--main", "README.rdoc", "--title", "shoe-0.1.12", "--inline-source"]
  s.require_paths = ["lib"]
  s.requirements = ["git"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Another take on hoe, jeweler & friends.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cucumber>, [">= 0"])
      s.add_runtime_dependency(%q<gemcutter>, [">= 0"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<gemcutter>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<gemcutter>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
