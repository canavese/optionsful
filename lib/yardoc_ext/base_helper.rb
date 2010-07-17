require 'pp'

module YARD::Templates::Helpers
  module BaseHelper

    # Adds additional test that only includes Objects that contain a URL tag
    def run_verifier(list)
        
      if options[:verifier]
        list.reject! {|item| options[:verifier].call(item).is_a?(FalseClass) }
      end

	    reject_module(list)
      reject_without_url(list)
      reject_without_topic(list)
      
      list
    end

    def reject_module(list)
    	list.reject! { |object| [:root, :module].include?(object.type) }
  	end
	
    def reject_without_url(list)
      list.reject!  { |object| [:class,:method].include?(object.type) and object.tags("url").empty? }
    end

    def reject_without_topic(list)
      list.reject!  { |object| [:class].include?(object.type) and object.tags("topic").empty? }
    end
    
  end
end