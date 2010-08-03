require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe Baurets::Optionsful::Config do

  include Rack::Test::Methods

  context "Config carries specific settings" do
    
    describe "when there's no custom config file, use expected default settings" do
      
      it "the Link header generation must be disabled" do
        config = Baurets::Optionsful::Config.new("file_error.txt")
        config.link.should be false
      end
      
    end
    
    describe "when there is a custom config file, load the settings from it" do
      
      it "the Link header generation must be disabled" do
        file = File.join(File.dirname(__FILE__), 'config', 'optionsful_link_false.yml')
        config = Baurets::Optionsful::Config.new(file)
        config.link.should be false
      end
      
      it "the Link header generation must be enabled" do
        config = Baurets::Optionsful::Config.new(File.join(File.dirname(__FILE__), 'config', 'optionsful.yml'))
        config.link.should be true
      end
      
      it "if the Link header generation is enabled, host value must be set" do
        config = Baurets::Optionsful::Config.new(File.join(File.dirname(__FILE__), 'config', 'optionsful.yml'))
        config.link.should be true
        config.host.empty?.should_not be true
      end
      
      it "if the Link header generation is enabled, host value accepts 'auto'" do
        config = Baurets::Optionsful::Config.new(File.join(File.dirname(__FILE__), 'config', 'optionsful_host_auto.yml'))
        config.link.should be true
        config.host.should == "auto"
      end
      
    end

  end
end