require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Baurets::Optionsful::Config do

  include Rack::Test::Methods

  context "Config carries specific settings" do

    describe "when there's NO custom config file, use expected default settings" do

      it "the Link header generation must be disabled" do
        config = Baurets::Optionsful::Config.new("file_error.txt")
        config.link.should be false
      end

    end

    describe "when there is a custom config file, load the settings from it" do

      before(:each) do
        @config = nil
      end

      it "the Link header generation must be disabled" do
        @config = Baurets::Optionsful::Config.new()
        @config.link.should be false
      end

      it "the Link header generation must be disabled (file found but looks corrupted!)" do
        FileUtils.cp File.join(Rails.root, 'samples', 'optionsful_bug.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
        @config = Baurets::Optionsful::Config.new
        @config.link.should == false
      end

      it "the Link header generation must be disabled (file given but looks corrupted!)" do
        @config = Baurets::Optionsful::Config.new(File.join(Rails.root, 'samples', 'optionsful_bug.yml'))
        @config.link.should be false
      end
      
      it "the Link header generation must be enabled" do
        @config = Baurets::Optionsful::Config.new(nil, {:link => true})
        @config.link.should be true
      end

      it "the Link header generation must be enabled (file found)" do
        FileUtils.cp File.join(Rails.root, 'samples', 'optionsful_true.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
        @config = Baurets::Optionsful::Config.new()
        @config.link.should be true
      end

      it "if the Link header generation is enabled, host value must be set" do
        @config = Baurets::Optionsful::Config.new(File.join(Rails.root, 'samples', 'optionsful_true.yml'))
        @config.link.should be true
        @config.host.empty?.should_not be true
      end

      it "if the Link header generation is enabled, host value accepts 'auto'" do
        @config = Baurets::Optionsful::Config.new(File.join(File.dirname(__FILE__), 'config', 'optionsful_host_auto.yml'))
        @config.link.should be true
        @config.host.should == "auto"
      end
      
      after(:each) do
        FileUtils.rm [File.join(Rails.root, 'config', 'optionsful.yml')] if File.exist? File.join(Rails.root, 'config', 'optionsful.yml')
        @config = nil
      end
      
      after(:all) do
        FileUtils.rm [File.join(Rails.root, 'config', 'optionsful.yml')] if File.exist? File.join(Rails.root, 'config', 'optionsful.yml')
        @config = nil
      end

    end

  end
end