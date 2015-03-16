require 'pathname'
require Pathname.new(__dir__) + 'minitest_helper'

class TestJenkinsJunitBuilder < MiniTest::Test
  def test_that_it_has_a_version_number
    refute_nil ::JenkinsJunitBuilder::VERSION
  end

  def test_system_message_return_value_initialized
    stack_trace = <<TXT
 create mode 100644 fonts/helveticaneue/HelveticaNeueItalic.ttf
 create mode 100644 fonts/helveticaneue/HelveticaNeueLight.ttf
 create mode 100644 fonts/helveticaneue/HelveticaNeueLightItalic.ttf
 create mode 100644 fonts/helveticaneue/HelveticaNeueMedium.ttf
 create mode 100644 fonts/helveticaneue/HelveticaNeueMediumItalic.ttf
TXT

    system_out = JenkinsJunitBuilder::SystemMessage.new stack_trace

    assert_equal stack_trace, system_out.to_s, 'System message has not kept the input text in the original form submitted at initialization'
  end

  def test_system_message_return_value
    stack_trace = <<TXT
  Minitest::Skip: Skipped, no message given
/home/ikon/src/rocksteady/git/jenkins_junit_builder/test/test_jenkins_junit_builder.rb:39:in `test_building_new_report'

  Minitest::Skip: Skipped, no message given
/home/ikon/src/rocksteady/git/jenkins_junit_builder/test/test_jenkins_junit_builder.rb:54:in `test_appending_to_existing_report'
   Finished in 0.00272s
4 tests, 2 assertions, 0 failures, 0 errors, 2 skips
TXT

    system_err         = JenkinsJunitBuilder::SystemMessage.new
    system_err.message = stack_trace
    system_err << 'a new line'

    expected = stack_trace + "\na new line"

    assert_equal expected, system_err.to_s, 'System message has not kept the input text in the original form'
  end

  def test_building_new_report
    t_passed           = JenkinsJunitBuilder::Case.new
    t_passed.name      = 'My first test case'
    t_passed.time      = 65
    t_passed.classname = 'FirstTestSuite'
    t_passed.result    = JenkinsJunitBuilder::Case::RESULT_PASSED

    t_failed                    = JenkinsJunitBuilder::Case.new
    t_failed.name               = 'My failing functionality'
    t_failed.classname          = 'FirstTestSuite'
    t_failed.result             = JenkinsJunitBuilder::Case::RESULT_FAILURE
    t_failed.message            = 'timeout reached'
    t_failed.system_out.message = 'some thing went wrong'
    t_failed.system_err.message = 'give me a stacktrace or something'

    t_suite      = JenkinsJunitBuilder::Suite.new
    t_suite.name = 'Testing some cases'
    t_suite.add_case t_passed
    t_suite.add_case t_failed

    actual = t_suite.build_report

    expected = <<XML
<testsuites>
  <testsuite name="Testing some cases">
    <testcase name="My first test case" time="65" classname="FirstTestSuite"/>
    <testcase name="My failing functionality" classname="FirstTestSuite">
      <failure message="timeout reached"/>
      <system-out>some thing went wrong</system-out>
      <system-err>give me a stacktrace or something</system-err>
    </testcase>
  </testsuite>
</testsuites>
XML
    expected.strip!

    assert_equal expected, actual
  end

  def test_dump_file_not_specified
    assert_raises(JenkinsJunitBuilder::FileNotFoundException) {
      t_suite = JenkinsJunitBuilder::Suite.new
      t_suite.write_report_file
    }
  end

  def test_dump_report_file
    _report_path = '/tmp/jenkins_junit_builder_test_dump_report_file.xml'

    t_passed           = JenkinsJunitBuilder::Case.new
    t_passed.name      = 'My first test case'
    t_passed.time      = 65
    t_passed.classname = 'FirstTestSuite'
    t_passed.result    = JenkinsJunitBuilder::Case::RESULT_PASSED

    t_failed                    = JenkinsJunitBuilder::Case.new
    t_failed.name               = 'My failing functionality'
    t_failed.classname          = 'FirstTestSuite'
    t_failed.result             = JenkinsJunitBuilder::Case::RESULT_FAILURE
    t_failed.message            = 'timeout reached'
    t_failed.system_out.message = 'some thing went wrong'
    t_failed.system_err.message = 'give me a stacktrace or something'

    t_suite             = JenkinsJunitBuilder::Suite.new
    t_suite.report_path = _report_path
    t_suite.name        = 'Testing some cases'
    t_suite.add_case t_passed
    t_suite.add_case t_failed

    actual = t_suite.write_report_file

    expected = <<XML
<testsuites>
  <testsuite name="Testing some cases">
    <testcase name="My first test case" time="65" classname="FirstTestSuite"/>
    <testcase name="My failing functionality" classname="FirstTestSuite">
      <failure message="timeout reached"/>
      <system-out>some thing went wrong</system-out>
      <system-err>give me a stacktrace or something</system-err>
    </testcase>
  </testsuite>
</testsuites>
XML
    expected.strip!

    File::delete _report_path
    assert_equal expected, actual
  end

  def test_dump_report_file_appending
    _report_path = '/tmp/jenkins_junit_builder_test_dump_report_file.xml'

    existing_report_content = <<XML
<testsuites>
  <testsuite name="Testing a case">
    <testcase name="My zero test case" time="5" classname="FirstTestSuite"/>
  </testsuite>
</testsuites>
XML
    File.write _report_path, existing_report_content

    t_passed           = JenkinsJunitBuilder::Case.new
    t_passed.name      = 'My first test case'
    t_passed.time      = 65
    t_passed.classname = 'FirstTestSuite'
    t_passed.result    = JenkinsJunitBuilder::Case::RESULT_PASSED

    t_failed                    = JenkinsJunitBuilder::Case.new
    t_failed.name               = 'My failing functionality'
    t_failed.classname          = 'FirstTestSuite'
    t_failed.result             = JenkinsJunitBuilder::Case::RESULT_FAILURE
    t_failed.message            = 'timeout reached'
    t_failed.system_out.message = 'some thing went wrong'
    t_failed.system_err.message = 'give me a stacktrace or something'

    t_suite               = JenkinsJunitBuilder::Suite.new
    t_suite.report_path   = _report_path
    t_suite.append_report = true
    t_suite.name          = 'Testing some cases'
    t_suite.add_case t_passed
    t_suite.add_case t_failed

    actual = t_suite.write_report_file

    expected = <<XML
<testsuites>
  <testsuite name="Testing a case">
    <testcase name="My zero test case" time="5" classname="FirstTestSuite"/>
  </testsuite>
  <testsuite name="Testing some cases">
    <testcase name="My first test case" time="65" classname="FirstTestSuite"/>
    <testcase name="My failing functionality" classname="FirstTestSuite">
      <failure message="timeout reached"/>
      <system-out>some thing went wrong</system-out>
      <system-err>give me a stacktrace or something</system-err>
    </testcase>
  </testsuite>
</testsuites>
XML
    expected.strip!

    File::delete _report_path
    assert_equal expected, actual
  end
end
