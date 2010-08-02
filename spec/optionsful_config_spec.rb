require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe Baurets::Optionsful::Config do

  include Rack::Test::Methods

  context "Config carries specific settings" do

    describe "try to find the custom configuration file" do

      it "if the custom configuration file exist, try to load settings from it" do
        config = Baurets::Optionsful::Config.new( {:file => File.join(File.dirname(__FILE__), '..', '..', 'samples', 'optionsful.yml'), :environment => "test" })
        config.base_path.should == "/test"
      end

      it "if the custom configuration file exist and is not valid, keep the default settings" do
        config = Baurets::Optionsful::Config.new( {:file => File.join(File.dirname(__FILE__), 'spec.opts'), :environment => "test" })
        config.base_path.should == "/optionsful"
      end

      it "if no configuration file is informed or found, do load the default settings" do
        config = Baurets::Optionsful::Config.new
        config.base_path.should == "/optionsful"
      end

      it "if RAILS_ROOT is defined, look for the custom configuration file on its config folder" do
        Baurets::Optionsful::Config.const_set(:RAILS_ROOT, File.dirname(__FILE__))
        config = Baurets::Optionsful::Config.new
        config.base_path.should == "/optionsful" 
      end

      it "and does not exist, keep default settings" do
        config = Baurets::Optionsful::Config.new( {:file => File.join(File.dirname(__FILE__), 'fixtures', 'optionsful_xxx.yml'), :environment => "test" })
        config.base_path.should == "/optionsful"
      end

    end

  end
end