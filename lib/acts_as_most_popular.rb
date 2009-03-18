module BrownPunk
  module Acts #:nodoc:
    module Popular #:nodoc:
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Creates methods for locating the most popular records in a table based on the number of times
        # they appear.
        #
        #  class User < ActiveRecord::Base
        #    acts_as_most_popular
        #  end
        #
        # A finder is created for each field in the table, as a pluralized name
        #    
        #    User.most_popular_last_names
        #    User.most_popular_ages
        #
        # The default limit is 5, but the limit can be changed by passing <tt>:limit => 10</tt> to the macro
        #
        # The finder methods return an array of values by default.
        #
        #   User.most_popular_first_names
        #   ["Brian", "Shane", "Chris", "Dennis"]
        #
        # However, you can also retrieve the frequency by passing <tt>:frequency => true</tt> as an option to the finder.
        # When this option is present, the finder will return a collection of objects instead of a simple array.  
        #   names = User.most_popular_first_names
        #     names.first.name 
        #        "Brian"
        #     names.first.frequency
        #        "25"
        def acts_as_most_popular(options = {})
          write_inheritable_attribute(:acts_as_most_popular_options, {
            :limit => options[:limit] 
          })
          
          class_inheritable_reader :acts_as_most_popular_options
  
          popular_methods = []
          column_names.each do |column|
            popular_methods << %(
              def self.most_popular_#{column.pluralize}(options={})
                unless acts_as_most_popular_options[:limit].blank?
                  limit = acts_as_most_popular_options[:limit]
                else
                  limit = 5
                end

                res = find(:all, :select => "#{column}, count(#{column}) as frequency",
                  :limit => limit,
                  :conditions => "#{column} is not null",
                  :group => "#{column}",
                  :order => "frequency desc")
                if options[:frequency]
                  res
                else
                  res.collect!{|r| r.#{column}}  
                end
              end              
            )
          end
          
          class_eval <<-EOV
            #{popular_methods.to_s}
          EOV
          
        end
        # Creates methods for locating the least popular records in a table based on the number of times
        # they appear.
        #
        #  class User < ActiveRecord::Base
        #    acts_as_least_popular
        #  end
        #
        # A finder is created for each field in the table, as a pluralized name
        #    
        #    User.least_popular_last_names
        #    User.least_popular_ages
        #
        # The default limit is 5, but the limit can be changed by passing <tt>:limit => 10</tt> to the macro
        #
        # The finder methods return an array of values by default.
        #
        #   User.least_popular_first_names
        #   ["Fred", "Esther", "George", "Newt"]
        #
        # However, you can also retrieve the frequency by passing <tt>:frequency => true</tt> as an option to the finder.
        # When this option is present, the finder will return a collection of objects instead of a simple array.  
        #   names = User.least_popular_first_names
        #     names.first.name 
        #        "Fred"
        #     names.first.frequency
        #        "25"
        def acts_as_least_popular(options = {})
          write_inheritable_attribute(:acts_as_least_popular_options, {
            :limit => options[:limit] 
          })
          
          class_inheritable_reader :acts_as_least_popular_options
  
          popular_methods = []
          column_names.each do |column|
            popular_methods << %(
              def self.least_popular_#{column.pluralize}(options={})
                unless acts_as_least_popular_options[:limit].blank?
                  limit = acts_as_least_popular_options[:limit]
                else
                  limit = 5
                end

                res = find(:all, :select => "#{column}, count(#{column}) as frequency",
                  :limit => limit,
                  :conditions => "#{column} is not null",
                  :group => "#{column}",
                  :order => "frequency asc")
                if options[:frequency]
                  res
                else
                  res.collect!{|r| r.#{column}}  
                end
              end              
            )
          end
          
          class_eval <<-EOV
            #{popular_methods.to_s}
          EOV
          
        end
        
        
        
      end
      

      
    end
  end
end