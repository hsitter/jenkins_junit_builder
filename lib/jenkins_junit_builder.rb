require 'jenkins_junit_builder/version'

module JenkinsJunitBuilder
  def say_hello
    puts 'hello works'
  end

  module_function :say_hello
end
