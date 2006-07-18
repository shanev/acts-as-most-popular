require 'acts_as_most_popular'
ActiveRecord::Base.send(:include, BrownPunk::Acts::Popular)