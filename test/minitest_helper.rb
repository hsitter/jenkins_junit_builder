require_relative '../lib/jenkins_junit_builder/version'
require_relative '../lib/jenkins_junit_builder/system_message'
require_relative '../lib/jenkins_junit_builder/case'
require_relative '../lib/jenkins_junit_builder/suite'
require_relative '../lib/jenkins_junit_builder/file_not_found_exception'

require 'minitest/autorun'
require 'minitest/reporters'

if ENV['MINITEST_REPORTER'] == 'RUBYMINE'
  Minitest::Reporters.use! Minitest::Reporters::RubyMineReporter.new
elsif RUBY_ENGINE != 'jruby'
  Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
end
