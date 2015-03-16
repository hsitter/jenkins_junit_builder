require 'pathname'
require Pathname.new(__dir__).parent + 'lib/jenkins_junit_builder/system_message'
require Pathname.new(__dir__).parent + 'lib/jenkins_junit_builder/case'
require Pathname.new(__dir__).parent + 'lib/jenkins_junit_builder/suite'
require Pathname.new(__dir__).parent + 'lib/jenkins_junit_builder/file_not_found_exception'

require 'minitest/autorun'
require 'minitest/reporters'

if ENV['MINITEST_REPORTER'] == 'RUBYMINE'
  Minitest::Reporters.use! Minitest::Reporters::RubyMineReporter.new
else
  Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
end
