# frozen_string_literal: true

require "rails_app/cli"

RSpec.describe RailsApp::CLI do
  describe "scaffolds new app" do
    let(:prompt) { instance_double(TTY::Prompt) }
    let(:styling_choices) {
      [
        {name: "Bootstrap", value: "bootstrap"},
        {name: "Tailwind CSS", value: "tailwind"},
        {name: "Bulma", value: "bulma"},
        {name: "PostCSS", value: "postcss"},
        {name: "SASS", value: "sass"}
      ]
    }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:ask).and_return("MyApp")
      allow(prompt).to receive(:yes?).and_return(true)
      allow(prompt).to receive(:select).and_return("propshaft", "importmap")
      allow_any_instance_of(RailsApp::Command).to receive(:run)
    end

    context "create new app with no cli arguments" do
      it "prompts for the app name and other options, then runs the command" do
        expect(prompt).to receive(:ask).with("What is the name of your application?", required: true)
        expect(prompt).to receive(:select).with("How would you like to manage assets?", %w[propshaft sprockets], default: "propshaft")
        expect(prompt).to receive(:select).with("How would you like to manage styling?", styling_choices, default: "bootstrap")
        expect(prompt).to receive(:select).with("Which database would you like to use?",
          %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc],
          default: "sqlite3")
        expect_any_instance_of(RailsApp::Command).to receive(:run)

        described_class.start([])
      end
    end

    context "create new app with cli arguments" do
      let(:options_data) { instance_double(RailsApp::OptionsData, app_name: "MyApp", default_assets: "propshaft", default_styling: "bootstrap", default_database: "sqlite3") }

      it "uses the cli arguments and does not prompt for app name" do
        expect(prompt).not_to receive(:ask)
        expect_any_instance_of(RailsApp::Command).to receive(:run)

        described_class.start(["MyApp"])
      end

      it "uses the cli arguments and does not prompt for assets" do
        expect(prompt).to receive(:select).with("How would you like to manage assets?", %w[propshaft sprockets], default: "sprockets")
        expect_any_instance_of(RailsApp::Command).to receive(:run)

        described_class.start(%w[MyApp sprockets])
      end

      it "uses the cli arguments and does not prompt for styling" do
        expect(prompt).to receive(:select).with("How would you like to manage styling?", styling_choices, default: "tailwind")
        expect_any_instance_of(RailsApp::Command).to receive(:run)

        described_class.start(%w[MyApp tailwind])
      end

      it "uses the cli arguments and does not prompt for database" do
        expect(prompt).to receive(:select).with("Which database would you like to use?",
          %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc],
          default: "postgresql")
        expect_any_instance_of(RailsApp::Command).to receive(:run)

        described_class.start(%w[MyApp postgresql])
      end
    end
  end
end
