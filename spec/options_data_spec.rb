# frozen_string_literal: true

require "rails_app/options_data"

RSpec.describe RailsApp::OptionsData do
  describe "#app_name" do
    it "returns the first option" do
      options_data = described_class.new(["my_app"])
      expect(options_data.app_name).to eq("my_app")
    end
  end

  describe "#default_assets" do
    it 'returns "sprockets" if it is included in the options' do
      options_data = described_class.new(["sprockets"])
      expect(options_data.default_assets).to eq("sprockets")
    end

    it 'returns "propshaft" if "sprockets" is not included in the options' do
      options_data = described_class.new(["not_sprockets"])
      expect(options_data.default_assets).to eq("propshaft")
    end
  end

  describe "#default_styling" do
    it "returns the correct styling option based on the options provided" do
      options_data = described_class.new(["tailwind"])
      expect(options_data.default_styling).to eq("tailwind")

      options_data = described_class.new(["bulma"])
      expect(options_data.default_styling).to eq("bulma")

      options_data = described_class.new(["postcss"])
      expect(options_data.default_styling).to eq("postcss")

      options_data = described_class.new(["sass"])
      expect(options_data.default_styling).to eq("sass")

      options_data = described_class.new(["bootstrap"])
      expect(options_data.default_styling).to eq("bootstrap")
    end

    it 'returns "bootstrap" if none of the specified options are included' do
      options_data = described_class.new(["not_an_option"])
      expect(options_data.default_styling).to eq("bootstrap")
    end
  end

  describe "#default_database" do
    it "returns the correct database option based on the options provided" do
      options_data = described_class.new(["postgresql"])
      expect(options_data.default_database).to eq("postgresql")

      options_data = described_class.new(["mysql"])
      expect(options_data.default_database).to eq("mysql")

      options_data = described_class.new(["trilogy"])
      expect(options_data.default_database).to eq("trilogy")

      options_data = described_class.new(["oracle"])
      expect(options_data.default_database).to eq("oracle")

      options_data = described_class.new(["sqlserver"])
      expect(options_data.default_database).to eq("sqlserver")

      options_data = described_class.new(["jdbcmysql"])
      expect(options_data.default_database).to eq("jdbcmysql")

      options_data = described_class.new(["jdbcsqlite3"])
      expect(options_data.default_database).to eq("jdbcsqlite3")

      options_data = described_class.new(["jdbcpostgresql"])
      expect(options_data.default_database).to eq("jdbcpostgresql")

      options_data = described_class.new(["jdbc"])
      expect(options_data.default_database).to eq("jdbc")
    end

    it 'returns "sqlite3" if none of the specified options are included' do
      options_data = described_class.new(["not_an_option"])
      expect(options_data.default_database).to eq("sqlite3")
    end
  end
end
