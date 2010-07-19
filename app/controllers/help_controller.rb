class HelpController < ApplicationController
  
  require 'net/http'
  require 'uri'
  
  
  def index
    
    controller_name = params[:id]
    puts `pwd`
    
    `yardoc 'app/controllers/*.rb' -t rest --backtrace -p ../../lib/yardoc_ext/templates -e /lib/yardoc_ext/yard-rest.rb --title 'Blog API'`
    puts params.inspect
    render :text => "Called index of HelpController - Here comes the doc.."
  end

  
end