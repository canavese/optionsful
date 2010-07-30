
module OptionsfulSpecHelper
  
  def app
    app = Rack::Builder.new {
      use Rack::CommonLogger
      use Rack::ShowExceptions
    } 
  end


  def fake_opts_app
    app = Rack::Builder.new {
      use Rack::CommonLogger
      use Rack::ShowExceptions
      use Baurets::Optionsful::Server
      map "/lobster" do
        use Rack::Lint
        run Rack::Lobster.new
      end
    }
  end
  
end