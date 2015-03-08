require 'minitest_helper'

class TestJenkinsJunitBuilder < MiniTest::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::JenkinsJunitBuilder::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
