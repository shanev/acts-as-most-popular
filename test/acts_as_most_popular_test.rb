require File.join(File.dirname(__FILE__), 'test_helper')

include BrownPunk::Acts::Popular

class Person < ActiveRecord::Base
  acts_as_most_popular
end

class ActsAsMostPopularTest < Test::Unit::TestCase
  fixtures :people
  
  def test_fixtures
    assert_equal 6, Person.count
  end
  
end
