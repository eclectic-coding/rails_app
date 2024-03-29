# frozen_string_literal: true

require "rails_app/cli"

RSpec.describe RailsApp::CLI do
  describe "scaffolds new app" do
    let(:prompt) { instance_double(TTY::Prompt) }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:ask).and_return("MyApp")
      allow(prompt).to receive(:yes?).and_return(true)
      allow(prompt).to receive(:select).and_return("propshaft", "importmap")
      allow(Dir).to receive(:chdir).and_yield
      allow_any_instance_of(RailsApp::Command).to receive(:run)
    end

    it "prompts for the app name and other options, then runs the command" do
      expect(prompt).to receive(:ask).with("What is the name of your application?", required: true)
      expect(prompt).to receive(:yes?).with("Would you like to skip-spring?")
      expect(prompt).to receive(:select).with("How would you like to manage assets?", %w[propshaft sprockets])
      expect(prompt).to receive(:select).with("Choose your javascript bundling?", %w[importmap esbuild bun])
      expect_any_instance_of(RailsApp::Command).to receive(:run)

      described_class.start
    end
  end
end
