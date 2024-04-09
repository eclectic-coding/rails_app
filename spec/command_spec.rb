# frozen_string_literal: true

require "rails_app/command"

RSpec.describe RailsApp::Command do
  let(:args) { {assets: "sprockets", styling: "tailwindcss", database: "sqlite3"} }
  describe "#template" do
    it "returns the path to the template file" do
      command = RailsApp::Command.new("my_app", args)
      expect(command.template).to eq(File.expand_path("../lib/rails_app/template/template.rb", __dir__))
    end
  end

  describe "#run" do
    it "executes the correct system command" do
      command = RailsApp::Command.new("my_app", args)
      expected_command = "rails new my_app --no-rc --skip-spring -j esbuild --css tailwindcss -T -m #{command.template}"

      expect(command).to receive(:system).with(expected_command)
      command.run
    end
  end

  describe "#skip_spring" do
    it "returns the skip spring option" do
      command = RailsApp::Command.new("my_app", args)
      expect(command.skip_spring).to eq("--skip-spring")
    end
  end

  describe "#skip_action_mailer" do
    context "when action mailer is not skipped" do
      it "returns nil" do
        command = RailsApp::Command.new("my_app", args)
        expect(command.skip_action_mailer).to be_nil
      end
    end

    context "when action mailer is skipped" do
      it "returns the skip action mailer option" do
        mailer_args = {assets: "sprockets", styling: "tailwindcss", database: "sqlite3", action_mailer: true}
        command = RailsApp::Command.new("my_app", mailer_args)
        expect(command.skip_action_mailer).to eq("--skip-action-mailer")
      end
    end
  end

  describe "#skip_action_mailbox" do
    context "when action mailbox is not skipped" do
      it "returns nil" do
        command = RailsApp::Command.new("my_app", args)
        expect(command.skip_action_mailbox).to be_nil
      end
    end

    context "when action mailbox is skipped" do
      it "returns the skip action mailbox option" do
        mailbox_args = {assets: "sprockets", styling: "tailwindcss", database: "sqlite3", action_mailbox: true}
        command = RailsApp::Command.new("my_app", mailbox_args)
        expect(command.skip_action_mailbox).to eq("--skip-action-mailbox")
      end
    end
  end

  describe "#skip_action_storage" do
    context "when action storage is not skipped" do
      it "returns nil" do
        command = RailsApp::Command.new("my_app", args)
        expect(command.skip_action_storage).to be_nil
      end
    end

    context "when action storage is skipped" do
      it "returns the skip action storage option" do
        storage_args = {assets: "sprockets", styling: "tailwindcss", database: "sqlite3", action_storage: true}
        command = RailsApp::Command.new("my_app", storage_args)
        expect(command.skip_action_storage).to eq("--skip-active-storage")
      end
    end
  end

  describe "#database_adapter" do
    context "when the database is sqlite3" do
      it "returns nil" do
        command = RailsApp::Command.new("my_app", args)
        expect(command.database_adapter).to be_nil
      end
    end

    context "when the database is not sqlite3" do
      it "returns the database adapter option" do
        command = RailsApp::Command.new("my_app", assets: "sprockets", styling: "tailwindcss", database: "postgresql")
        expect(command.database_adapter).to eq("-d postgresql")
      end
    end
  end

  describe "#javascript_bundling" do
    it "returns the javascript bundling option" do
      command = RailsApp::Command.new("my_app", args)
      expect(command.javascript_bundling).to eq("-j esbuild")
    end
  end

  describe "#asset_management" do
    context "when the assets are sprockets" do
      it "returns nil" do
        command = RailsApp::Command.new("my_app", args)
        expect(command.asset_management).to be_nil
      end
    end

    context "when the assets are not sprockets" do
      it "returns the asset management option" do
        new_args = {assets: "propshaft", styling: "tailwindcss", database: "sqlite3"}
        command = RailsApp::Command.new("my_app", new_args)
        expect(command.asset_management).to eq("-a propshaft")
      end
    end
  end

  describe "#styling_framework" do
    context "when styling is bulma" do
      it "returns the styling framework option" do
        bulma_args = {assets: "sprockets", styling: "bulma", database: "sqlite3"}
        command = RailsApp::Command.new("my_app", bulma_args)
        expect(command.styling_framework).to eq("--css bulma")
      end
    end

    context "when styling is tailwind" do
      it "returns the styling framework option" do
        command = RailsApp::Command.new("my_app", args)
        expect(command.styling_framework).to eq("--css tailwindcss")
      end
    end

    context "when styling is postcss" do
      it "returns the styling framework option" do
        command = RailsApp::Command.new("my_app", {assets: "sprockets", styling: "postcss", database: "sqlite3"})
        expect(command.styling_framework).to eq("--css postcss")
      end
    end

    context "when styling is sass" do
      it "returns the styling framework option" do
        command = RailsApp::Command.new("my_app", {assets: "sprockets", styling: "sass", database: "sqlite3"})
        expect(command.styling_framework).to eq("--css sass")
      end
    end
  end

  describe "#testing_framework" do
    it "returns the testing framework option" do
      command = RailsApp::Command.new("my_app", {assets: "sprockets", styling: "tailwindcss", database: "sqlite3"})
      expect(command.testing_framework).to eq("-T")
    end
  end
end
