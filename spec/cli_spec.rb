# frozen_string_literal: true

require "rails_app/cli"

RSpec.describe RailsApp::CLI do
  describe "scaffolds new app" do
    let(:prompt) { instance_double(TTY::Prompt) }
    let(:config_file) { instance_double(RailsApp::ConfigFile) }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(RailsApp::ConfigFile).to receive(:new).and_return(config_file)
    end

    describe ".start" do
      context "when config file exists and user wants to use it" do
        before do
          prompt = instance_double(TTY::Prompt)
          allow(prompt).to receive(:yes?).and_return(true)
          allow(TTY::Prompt).to receive(:new).and_return(prompt)
          config_file = instance_double(RailsApp::ConfigFile)
          allow(config_file).to receive(:read).and_return({"assets" => "propshaft", "styling" => "bootstrap", "database" => "postgresql"})
          allow(RailsApp::ConfigFile).to receive(:new).and_return(config_file)
          options_data = instance_double(RailsApp::OptionsData)
          allow(options_data).to receive(:app_name).and_return("test_app")
          allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)
        end

        it "creates an app with the existing configuration" do
          expect(RailsApp::CLI).to receive(:create_app).with("test_app", {"assets" => "propshaft", "styling" => "bootstrap", "database" => "postgresql"})
          RailsApp::CLI.start({"assets" => "propshaft", "styling" => "bootstrap", "database" => "postgresql"})
        end
      end

      context "when config file does not exist or user does not want to use it" do
        before do
          prompt = instance_double(TTY::Prompt)
          allow(prompt).to receive(:ask).and_return("test_app")
          allow(prompt).to receive(:yes?).and_return(true)
          allow(TTY::Prompt).to receive(:new).and_return(prompt)
          config_file = instance_double(RailsApp::ConfigFile)
          allow(config_file).to receive(:read).and_return(nil)
          allow(config_file).to receive(:set)
          allow(config_file).to receive(:write)
          allow(config_file).to receive(:full_path).and_return("/path/to/config_file")
          allow(RailsApp::ConfigFile).to receive(:new).and_return(config_file)
          options_data = instance_double(RailsApp::OptionsData)
          allow(options_data).to receive(:app_name).and_return("test_app")
          allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)
        end

        it "creates an app with the new configuration" do
          allow(RailsApp::CLI).to receive(:menu).and_return({assets: "sprockets", styling: "bootstrap", database: "postgresql"})
          expect(RailsApp::CLI).to receive(:create_app).with("test_app", {assets: "sprockets", styling: "bootstrap", database: "postgresql"})
          RailsApp::CLI.start({"assets" => "sprockets", "styling" => "bootstrap", "database" => "postgresql"})
        end
      end
    end
  end

  describe ".menu" do
    let(:prompt) { instance_double(TTY::Prompt) }

    before do
      allow(prompt).to receive(:select).with("How would you like to manage assets?", %w[propshaft sprockets]).and_return("sprockets")
      allow(prompt).to receive(:select).with("How would you like to manage styling?", %w[bootstrap tailwind bulma postcss sass]).and_return("bootstrap")
      allow(prompt).to receive(:select).with("Which database would you like to use?",
        %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]).and_return("postgresql")
    end

    it "returns a hash with the selected options" do
      result = RailsApp::CLI.menu("test_app", prompt)

      expect(result).to eq({app_name: "test_app", assets: "sprockets", styling: "bootstrap", database: "postgresql"})
    end
  end
end
