require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Baurets::Optionsful::Configurator do

  include Rack::Test::Methods

  context "Configuration do handle the custom settings" do

    describe "if no directions were explicitly given, act as using the default settings" do
      
      before do
        delete_configuration_file
      end

      it "the Link header generation must be disabled" do
        configuration[:link].should be false
      end

    end

    describe "when there is a custom configuration file, load the settings from it" do

      before(:each) do
        FileUtils.rm [File.join(Rails.root, 'config', 'optionsful.yml')] if File.exist? File.join(Rails.root, 'config', 'optionsful.yml')
      end

      it "by default, the Link header generation must be disabled" do
        simulate_rake_yml_task
        configuration[:link].should be false
      end

      it "the Link header generation must be disabled (file looks corrupted!)" do
        FileUtils.cp File.join(Rails.root, 'samples', 'optionsful_bug.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
        configuration[:link].should be false
      end

      it "the Link header generation must be enabled" do
        FileUtils.cp File.join(Rails.root, 'samples', 'optionsful_true.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
        configuration[:link].should be true
      end

      it "if the Link header generation is enabled, host value must be set" do
        FileUtils.cp File.join(Rails.root, 'samples', 'optionsful_true.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
        configuration[:link].should be true
        configuration[:host].empty?.should_not be true
      end

      it "if the Link header generation is enabled, host value accepts 'auto'" do
        FileUtils.cp File.join(Rails.root, 'samples', 'optionsful_true.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
        configuration[:link].should be true
        configuration[:host].empty?.should_not be true
        configuration[:host].should == "auto"
      end

      after(:each) do
        delete_configuration_file
      end

      after(:all) do
        FileUtils.rm [File.join(Rails.root, 'config', 'optionsful.yml')] if File.exist? File.join(Rails.root, 'config', 'optionsful.yml')
      end

    end
  end
end