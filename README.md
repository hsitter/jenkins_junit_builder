[DRAFT - not released yet]

# Jenkins CI compatible Junit XML report builder

When you have your own home brewed testing framework but still want to use [Jenkins CI](http://jenkins-ci.org/) with it's standard [JUnit plugin](https://wiki.jenkins-ci.org/display/JENKINS/JUnit+Plugin), you may find yourself searching for a valid and recent documentation on how to create such XML documents. It's hard. Harder for newbies who want to learn how to set up/use Jenkins and make it useful to their projects.

The XSD schema that serves as a base of the XMLs generated can be found [here](https://svn.jenkins-ci.org/trunk/hudson/dtkit/dtkit-format/dtkit-junit-model/src/main/resources/com/thalesgroup/dtkit/junit/model/xsd/junit-7.xsd).

I have put together a [blog entry](http://ikonote.blogspot.ie/2015/03/how-to-create-jenins-ci-compatible.html) on describing how the XML is interpreted and presented by Jenkins.

Please not that this is my first Ruby Gem and I am building it primarily to serve the current project I am working on. Any suggestions on improving it is very welcomed! (^_^)

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


----------

TODO

----------


## Contributing

1. Fork it ( https://github.com/vadviktor/jenkins_junit_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
