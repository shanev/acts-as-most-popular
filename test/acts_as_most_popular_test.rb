require File.join(File.dirname(__FILE__), 'test_helper')
require 'pp'

include BrownPunk::Acts::Popular

class Person < ActiveRecord::Base
  acts_as_most_popular :limit => 5
end

class ActsAsMostPopularTest < Test::Unit::TestCase
  fixtures :people
  
  def test_fixtures
    assert_equal 6, Person.count
  end
  
  def test_popular_cities
    # returns an array of cities based on their popularity
    # the array is in order of the most frequently occurring
    # value in the column 
    cities = Person.most_popular_cities
    
    assert_equal 3, cities.size
    assert_equal "chicago", cities[0]
    assert_equal "new york", cities[1]
    assert_equal "hartford", cities[2]    
  end

  def test_most_popular_ages
    # numerical values are returned in order of decreasing mode
    ages = Person.most_popular_ages
    
    assert_equal 4, ages.size
    assert_equal 28, ages[0]
  end
end
