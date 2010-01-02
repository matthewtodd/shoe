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

  assert_equal am_i_expecting_to_see_something, send(standard_out_or_error).include?(message)
end

Then /^I should see a file "([^\"]*)"$/ do |path|
  assert file(path).exist?
end

Then /^the contents of "([^\"]*)" should still be "([^\"]*)"$/ do |path, expected|
  assert_equal expected, file(path).read
end
