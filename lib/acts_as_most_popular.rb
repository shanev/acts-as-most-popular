module BrownPunk
  module Acts #:nodoc:
    module Popular #:nodoc:
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def acts_as_most_popular(options = {})
          write_inheritable_attribute(:acts_as_most_popular_options, {
            :limit => options[:limit] 
          })
          
          class_inheritable_reader :acts_as_most_popular_options
  
          popular_methods = []
          column_names.each do |column|
            popular_methods << %(
              def self.most_popular_#{column.pluralize}
                unless acts_as_most_popular_options[:limit].blank?
                  limit = acts_as_most_popular_options[:limit]
                else
                  limit = 5
                end
                grouped  = find(:all).group_by { |c| c.#{column} }
                sorted  = grouped.sort { |a,b| a[1].size<=>b[1].size }.reverse
                Array.new(sorted.size < limit ? sorted.size : limit) { |i| sorted[i][1][0].#{column} }
              end              
            )
          end
          
          class_eval <<-EOV
            #{popular_methods.to_s}
          EOV
          
          include BrownPunk::Acts::Popular::InstanceMethods
          extend BrownPunk::Acts::Popular::SingletonMethods
        end
      end
      
      module SingletonMethods
      end
      
      module InstanceMethods
      end
      
    end
  end
end