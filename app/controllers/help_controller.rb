class HelpController < ApplicationController
  
  def index
    render :text => "Here comes the doc.."
  end
  
end