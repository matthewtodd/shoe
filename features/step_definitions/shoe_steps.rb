Given /^I have created a directory called "([^\"]*)"$/ do |name|
  create_directory(name)
end

Given /^I have created a file called "([^\"]*)" containing "([^\"]*)"$/ do |path, contents|
  create_file(path, contents)
end

When /^I run shoe inside "([^\"]*)"$/ do |path|
  inside_directory(path) { run_shoe }
end

Then /^I should see "([^\"]*)" on standard error$/ do |message|
  error_stream.should include(message)
end

Then /^I should see a file "([^\"]*)"$/ do |path|
  file(path).exist?.should == true
end

Then /^the contents of "([^\"]*)" should still be "([^\"]*)"$/ do |path, expected|
  file(path).read.should == expected
end
