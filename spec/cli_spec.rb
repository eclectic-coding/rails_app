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
          allow(config_file).to receive(:read).and_return({"assets" => "propshaft", "bundling" => "esbuild", "styling" => "bootstrap", "database" => "postgresql"})
          allow(RailsApp::ConfigFile).to receive(:new).and_return(config_file)
          options_data = instance_double(RailsApp::OptionsData)
          allow(options_data).to receive(:app_name).and_return("test_app")
          allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)
        end

        it "creates an app with the existing configuration" do
          expect(RailsApp::CLI).to receive(:create_app).with("test_app", {"assets" => "propshaft", "bundling" => "esbuild", "styling" => "bootstrap", "database" => "postgresql"})
          RailsApp::CLI.start({"assets" => "propshaft", "bundling" => "esbuild", "styling" => "bootstrap", "database" => "postgresql"})
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
    let(:options_data) { instance_double(RailsApp::OptionsData) }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)
    end

    it "returns user selected options" do
      allow(prompt).to receive(:select).and_return("esbuild", "bootstrap", "propshaft", "postgresql")
      allow(prompt).to receive(:yes?).and_return(false)

      expected_options = {
        bundling: "esbuild",
        styling: "bootstrap",
        assets: "propshaft",
        database: "postgresql",
        skip_spring: false,
        action_mailer: false,
        action_mailbox: false,
        action_text: false,
        action_storage: false,
        action_cable: false
      }

      expect(RailsApp::CLI.menu(prompt)).to eq(expected_options)
    end
  end

  describe ".create_app" do
    let(:command) { instance_double(RailsApp::Command) }

    before do
      allow(RailsApp::Command).to receive(:new).and_return(command)
    end

    it "runs the command to create a new app" do
      app_name = "test_app"
      args = {
        assets: "propshaft",
        styling: "bootstrap",
        database: "postgresql",
        action_mailer: false,
        action_mailbox: false,
        action_text: false,
        action_storage: false,
        action_cable: false
      }

      expect(command).to receive(:run)
      RailsApp::CLI.create_app(app_name, args)
    end
  end
end
