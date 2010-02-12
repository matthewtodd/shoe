Given /^I have created a project called "([^\"]*)"$/ do |name|
  create_directory(name)
  create_file("#{name}/Gemfile", <<-END.gsub(/^\s*/, ''))
    source :gemcutter
    gem 'shoe'
  END
  run('bundle exec shoe', name)
  append_file("#{name}/Gemfile", "gem '#{name}', :path => File.expand_path('..', __FILE__)")
end

Given /^I have created a directory called "([^\"]*)"$/ do |name|
  create_directory(name)
end

Given /^I have created a file called "([^\"]*)" containing "([^\"]*)"$/ do |path, contents|
  create_file(path, contents)
end

Given /^I have created a file called "([^\"]*)" containing:$/ do |path, contents|
  create_file(path, contents)
end

When /^I replace "([^\"]*)" with "([^\"]*)" in the file "([^\"]*)"$/ do |search, replace, path|
  edit_file(path, search, replace)
end

When /^I (?:have )?run (.*) inside "([^\"]*)"$/ do |command, path|
  run(command, path)
end

Then /^I should(.*) see "([^\"]*)" on (standard.*)$/ do |negate, message, standard_out_or_error|
  standard_out_or_error.tr!(' ', '_')
  am_i_expecting_to_see_something = negate.strip.empty?
  contents = send(standard_out_or_error)

  assert_equal am_i_expecting_to_see_something, contents.include?(message), contents
end

Then /^I should see a file "([^\"]*)"$/ do |path|
  assert file(path).exist?
end

Then /^the contents of "([^\"]*)" should still be "([^\"]*)"$/ do |path, expected|
  assert_equal expected, file(path).read
end
