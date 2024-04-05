# frozen_string_literal: true

require "rails_app/command"

RSpec.describe RailsApp::Command do
  describe "#template" do
    it "returns the path to the template file" do
      command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
      expect(command.template).to eq(File.expand_path("../lib/rails_app/template/template.rb", __dir__))
    end
  end

  describe "#run" do
    it "executes the correct system command" do
      command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
      expected_command = "rails new my_app --no-rc --skip-spring -j esbuild --css tailwindcss -T -m #{command.template}"

      expect(command).to receive(:system).with(expected_command)
      command.run
    end
  end

  describe "#skip_spring" do
    it "returns the skip spring option" do
      command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
      expect(command.skip_spring).to eq("--skip-spring")
    end
  end

  describe "#database_adapter" do
    context "when the database is sqlite3" do
      it "returns nil" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
        expect(command.database_adapter).to be_nil
      end
    end

    context "when the database is not sqlite3" do
      it "returns the database adapter option" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "postgresql")
        expect(command.database_adapter).to eq("-d postgresql")
      end
    end
  end

  describe "#javascript_bundling" do
    it "returns the javascript bundling option" do
      command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
      expect(command.javascript_bundling).to eq("-j esbuild")
    end
  end

  describe "#asset_management" do
    context "when the assets are sprockets" do
      it "returns nil" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
        expect(command.asset_management).to be_nil
      end
    end

    context "when the assets are not sprockets" do
      it "returns the asset management option" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "propshaft", styling: "tailwindcss", database: "sqlite3")
        expect(command.asset_management).to eq("-a propshaft")
      end
    end
  end

  describe "#styling_framework" do
    context "when styling is bulma" do
      it "returns the styling framework option" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "bulma", database: "sqlite3")
        expect(command.styling_framework).to eq("--css bulma")
      end
    end

    context "when styling is tailwind" do
      it "returns the styling framework option" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
        expect(command.styling_framework).to eq("--css tailwindcss")
      end
    end

    context "when styling is postcss" do
      it "returns the styling framework option" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "postcss", database: "sqlite3")
        expect(command.styling_framework).to eq("--css postcss")
      end
    end

    context "when styling is sass" do
      it "returns the styling framework option" do
        command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "sass", database: "sqlite3")
        expect(command.styling_framework).to eq("--css sass")
      end
    end
  end

  describe "#testing_framework" do
    it "returns the testing framework option" do
      command = RailsApp::Command.new(app_name: "my_app", assets: "sprockets", styling: "tailwindcss", database: "sqlite3")
      expect(command.testing_framework).to eq("-T")
    end
  end
end