# coding: utf-8
require 'pathname'
require Pathname.new(__dir__) + 'lib/jenkins_junit_builder/version'

Gem::Specification.new do |spec|
  spec.name          = 'jenkins_junit_builder'
  spec.version       = JenkinsJunitBuilder::VERSION
  spec.authors       = ['Viktor Vad']
  spec.email         = ['vad.viktor@gmail.com']
  spec.summary       = %q{Build test reports in Jenkins CI JUnit XML format.}
  spec.description   = %q{A factory that helps you build Jenkins CI compatible JUnit XML reports for your tests.}
  spec.homepage      = 'https://github.com/vadviktor/jenkins_junit_builder'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
end
