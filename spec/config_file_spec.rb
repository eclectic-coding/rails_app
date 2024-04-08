# frozen_string_literal: true

require "rails_app/config_file"
require "securerandom" # Add this line

RSpec.describe RailsApp::ConfigFile do
  let(:config_file) do
    config = described_class.new
    config.instance_variable_get(:@config).filename = "rails_app-config-#{SecureRandom.uuid}"
    config
  end

  describe "#initialize" do
    it "initializes a new TTY::Config object" do
      expect(config_file.instance_variable_get(:@config)).to be_a(TTY::Config)
    end
  end

  describe "#exist?" do
    it "checks if the config file exists" do
      expect(config_file.exist?).to eq(false)
    end
  end

  describe "#set" do
    it "sets a key-value pair in the config" do
      config_file.set("key", "value")
      expect(config_file.instance_variable_get(:@config).fetch("key")).to eq("value")
    end
  end

  describe "#write" do
    it "writes the config to a file" do
      config_file.set("key", "value")
      config_file.write(force: true)
      expect(File.exist?(config_file.full_path)).to eq(true)
    end
  end

  describe "#full_path" do
    it "returns the full path of the config file" do
      full_path = config_file.full_path
      expect(full_path).to start_with(File.join(Dir.home, "rails_app-config-"))
      expect(full_path).to end_with(".yml")
    end
  end

  describe "#read" do
    it "reads the config from a file" do
      config_file.set("key", "value")
      config_file.write(force: true)
      expect(config_file.read).to eq({"key" => "value"})
    end
  end
end
