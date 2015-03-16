# Jenkins CI compatible Junit XML report builder

When you have your own home brewed testing framework but still want to use [Jenkins CI](http://jenkins-ci.org/) with it's standard [JUnit plugin](https://wiki.jenkins-ci.org/display/JENKINS/JUnit+Plugin), you may find yourself searching for a valid and recent documentation on how to create such XML documents. It's hard. Harder for newbies who want to learn how to set up/use Jenkins and make it useful to their projects.

The XSD schema that serves as a base of the XMLs generated can be found [here](https://svn.jenkins-ci.org/trunk/hudson/dtkit/dtkit-format/dtkit-junit-model/src/main/resources/com/thalesgroup/dtkit/junit/model/xsd/junit-7.xsd).

I have put together a [blog entry](http://ikonote.blogspot.ie/2015/03/how-to-create-jenins-ci-compatible.html) on describing how the XML is interpreted and presented by Jenkins.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jenkins_junit_builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jenkins_junit_builder

Since it uses [Nokogiri](http://www.nokogiri.org/) to build report XMLs, please refer to [Nokogiri's documentation](http://www.nokogiri.org/tutorials/installing_nokogiri.html) for more installation instructions if you run into build errors.


## Usage

Please note that understanding how to [read an XSD schema](http://www.w3.org/TR/xmlschema11-1/) (which is [not that hard](http://www.w3schools.com/schema/default.asp)) will really help navigating and understanding what properties are available and how to structure them.
Again, Jenkins looks like to work by this [XSD schema](https://svn.jenkins-ci.org/trunk/hudson/dtkit/dtkit-format/dtkit-junit-model/src/main/resources/com/thalesgroup/dtkit/junit/model/xsd/junit-7.xsd).

Since we are building our own testing system, I did something that is not soooo magical as a DSL with raibows and [Unikitties](http://lego.wikia.com/wiki/Unikitty).

----------

Let's report a pass:
```ruby
t_passed           = JenkinsJunitBuilder::Case.new
t_passed.name      = 'My first test case'
t_passed.time      = 65
t_passed.classname = 'FirstTestSuite'
t_passed.result    = JenkinsJunitBuilder::Case::RESULT_PASSED
```

Then a failure:
```ruby
t_failed                    = JenkinsJunitBuilder::Case.new
t_failed.name               = 'My failing functionality'
t_failed.classname          = 'FirstTestSuite'
t_failed.result             = JenkinsJunitBuilder::Case::RESULT_FAILURE
t_failed.message            = 'timeout reached'
t_failed.system_out.message = 'some thing went wrong'
t_failed.system_err.message = 'give me a stacktrace or something'
```

Add those to the suite:
```ruby
t_suite      = JenkinsJunitBuilder::Suite.new
t_suite.name = 'Testing some cases'
t_suite.add_case t_passed
t_suite.add_case t_failed
```

And bake them:
```ruby
xml_report = t_suite.build_report
```

Into this:
```xml
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
```

Please refer to the tests and code for more guidance for the time being.

----------


## Contributing

1. Fork it ( https://github.com/vadviktor/jenkins_junit_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
