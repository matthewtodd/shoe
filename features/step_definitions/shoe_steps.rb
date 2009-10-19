Given /^I have created a directory called "([^\"]*)"$/ do |name|
  create_directory(name)
end

Given /^I have created a file called "([^\"]*)" containing "([^\"]*)"$/ do |path, contents|
  create_file(path, contents)
end

Given /^I have created a file called "([^\"]*)" containing:$/ do |path, contents|
  create_file(path, contents)
end

When /^I (?:have )?run (.*) inside "([^\"]*)"$/ do |command, path|
  run(command, path)
end

Then /^I (should.*) see "([^\"]*)" on (standard.*)$/ do |should_or_should_not, message, standard_out_or_error|
  standard_out_or_error.tr!(' ', '_')
  should_or_should_not.tr!(' ', '_')

  send(standard_out_or_error).send(should_or_should_not, include(message))
end

Then /^I should see a file "([^\"]*)"$/ do |path|
  file(path).exist?.should == true
end

Then /^the contents of "([^\"]*)" should still be "([^\"]*)"$/ do |path, expected|
  file(path).read.should == expected
end
