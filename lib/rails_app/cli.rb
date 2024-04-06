# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start(args)
      prompt = TTY::Prompt.new
      options_data = OptionsData.new(args)
      config_file = ConfigFile.new

      app_name = options_data.app_name || prompt.ask("What is the name of your application?", required: true)

      # Read the configuration and ask the user if they want to use it
      config_options = config_file.read
      if config_options && prompt.yes?("Do you want to use this configuration? #{config_options}")
        options_data = OptionsData.from_config(config_options)
      end

      config_options = self.menu(app_name, options_data, prompt)

      # Ask the user if they wish to save their configuration
      if prompt.yes?("Do you wish to save your configuration?")
        # Iterate over the hash and set the configuration
        config_options.each do |key, value|
          next if key == :app_name
          config_file.set(key, value)
        end
        config_file.write(force: true)
        puts "Configuration saved successfully @ #{config_file.full_path}"
      end

      Command.new(config_options).run
    end

    def self.menu(app_name, options_data, prompt)
      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets], default: options_data.default_assets)
      styling = prompt.select("How would you like to manage styling?", %w[bootstrap tailwind bulma postcss sass], default: options_data.default_styling)
      database = prompt.select("Which database would you like to use?",
                               %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc],
                               default: options_data.default_database)

      { app_name: app_name, assets: assets, styling: styling, database: database }
    end
  end
end
