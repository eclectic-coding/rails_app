# frozen_string_literal: true

require "rails_app/cli"

RSpec.describe RailsApp::CLI do
  describe "scaffolds new app" do
    let(:prompt) { instance_double(TTY::Prompt) }
    let(:config_file) { instance_double(RailsApp::ConfigFile) }
    let(:options_data) { instance_double(RailsApp::OptionsData) }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(RailsApp::ConfigFile).to receive(:new).and_return(config_file)
      allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)
    end

    describe '.start' do
      context 'when config file exists and user wants to use it' do
        before do
          prompt = instance_double(TTY::Prompt)
          allow(prompt).to receive(:yes?).and_return(true)
          allow(TTY::Prompt).to receive(:new).and_return(prompt)
          config_file = instance_double(RailsApp::ConfigFile)
          allow(config_file).to receive(:read).and_return({ "app_name" => "test_app", "assets" => "propshaft", "styling" => "bootstrap", "database" => "postgresql" })
          allow(RailsApp::ConfigFile).to receive(:new).and_return(config_file)
          options_data = instance_double(RailsApp::OptionsData)
          allow(options_data).to receive(:app_name).and_return("test_app")
          allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)
        end

        it 'creates an app with the existing configuration' do
          expect(RailsApp::CLI).to receive(:create_app).with({ "app_name" => "test_app", "assets" => "propshaft", "styling" => "bootstrap", "database" => "postgresql" })
          RailsApp::CLI.start({ "app_name" => "test_app", "assets" => "propshaft", "styling" => "bootstrap", "database" => "postgresql" })
        end
      end

      context 'when config file does not exist or user does not want to use it' do
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

        it 'creates an app with the new configuration' do
          allow(RailsApp::CLI).to receive(:menu).and_return({ app_name: "test_app", assets: "sprockets", styling: "bootstrap", database: "postgresql" })
          expect(RailsApp::CLI).to receive(:create_app).with({ app_name: "test_app", assets: "sprockets", styling: "bootstrap", database: "postgresql" })
          RailsApp::CLI.start({ "app_name" => "test_app", "assets" => "sprockets", "styling" => "bootstrap", "database" => "postgresql" })
        end
      end
    end
  end

  describe '.menu' do
    let(:prompt) { instance_double(TTY::Prompt) }
    let(:options_data) { instance_double(RailsApp::OptionsData) }

    before do
      prompt = instance_double(TTY::Prompt)
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      options_data = instance_double(RailsApp::OptionsData)
      allow(options_data).to receive(:default_assets).and_return('sprockets')
      allow(options_data).to receive(:default_styling).and_return('bootstrap')
      allow(options_data).to receive(:default_database).and_return('postgresql')
      allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)
    end

    it 'returns a hash with the selected options' do
      options_data = instance_double(RailsApp::OptionsData)
      allow(options_data).to receive(:default_assets).and_return('sprockets')
      allow(options_data).to receive(:default_styling).and_return('bootstrap')
      allow(options_data).to receive(:default_database).and_return('postgresql')
      allow(RailsApp::OptionsData).to receive(:new).and_return(options_data)

      allow(prompt).to receive(:select).with("How would you like to manage assets?", %w[propshaft sprockets], default: options_data.default_assets).and_return('sprockets')
      allow(prompt).to receive(:select).with("How would you like to manage styling?", %w[bootstrap tailwind bulma postcss sass], default: options_data.default_styling).and_return('bootstrap')
      allow(prompt).to receive(:select).with("Which database would you like to use?",
                                             %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc],
                                             default: options_data.default_database).and_return('postgresql')

      result = RailsApp::CLI.menu('test_app', options_data, prompt)

      expect(result).to eq({ app_name: 'test_app', assets: 'sprockets', styling: 'bootstrap', database: 'postgresql' })
    end
  end
end
