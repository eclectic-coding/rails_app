# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start(args)
      prompt = TTY::Prompt.new

      options_data = OptionsData.new(args)
      config_file = ConfigFile.new
      puts "Configuration file: #{config_file.exist?}"

      app_name = options_data.app_name || prompt.ask("What is the name of your application?", required: true)

      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets], default: options_data.default_assets)
      styling_choices = [
        {name: "Bootstrap", value: "bootstrap"},
        {name: "Tailwind CSS", value: "tailwind"},
        {name: "Bulma", value: "bulma"},
        {name: "PostCSS", value: "postcss"},
        {name: "SASS", value: "sass"}
      ]
      styling = prompt.select("How would you like to manage styling?", styling_choices, default: options_data.default_styling)

      database = prompt.select("Which database would you like to use?",
        %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc],
        default: options_data.default_database)

      # Collect all configuration options into a hash
      config_options = {
        app_name: app_name,
        assets: assets,
        styling: styling,
        database: database
      }

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


      Command.new(app_name: app_name, assets: assets, styling: styling, database: database).run
    end
  end
end
