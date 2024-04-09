# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start(args)
      # puts "args: #{args}"
      prompt = TTY::Prompt.new
      options_data = OptionsData.new(args)
      config_file = ConfigFile.new

      app_name = options_data.app_name || prompt.ask("What is the name of your application?", required: true)

      # Read from existing configuration and ask the user if they want to use it
      config_options = config_file.read

      if config_options && prompt.yes?("Do you want to use this configuration? #{config_options}")
        create_app(app_name, config_options) # standard:disable Style/IdenticalConditionalBranches
      else
        config_options = menu(prompt, options_data) # open cli menus to get user input
        # puts "config_options: #{config_options}"
        save_config(prompt, config_file, config_options) # save their configuration
        create_app(app_name, config_options) # standard:disable Style/IdenticalConditionalBranches
      end
    end

    def self.menu(prompt, option_data = nil)
      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets], default: option_data&.default_assets)
      styling = prompt.select("How would you like to manage styling?", %w[bootstrap tailwind bulma postcss sass], default: option_data&.default_styling)
      database = prompt.select("Which database would you like to use?", %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc], default: option_data&.default_database)
      action_mailer = prompt.yes?("Would you like to SKIP Action Mailer?", default: option_data&.default_action_mailer)
      action_mailbox = prompt.yes?("Would you like to SKIP Action Mailbox?", default: option_data&.default_action_mailbox)
      action_text = prompt.yes?("Would you like to SKIP Action Text?", default: option_data&.default_action_text)
      action_storage = prompt.yes?("Would you like to SKIP Active Storage?", default: option_data&.default_action_storage)
      action_cable = prompt.yes?("Would you like to SKIP Active Cable?", default: option_data&.default_action_cable)

      { assets: assets, styling: styling, database: database, action_mailer: action_mailer, action_mailbox: action_mailbox,
        action_text: action_text, action_storage: action_storage, action_cable: action_cable }
    end

    def self.create_app(app_name, args)
      Command.new(app_name, args).run
    end

    def self.save_config(prompt, config_file, config_options)
      if prompt.yes?("Do you wish to save your configuration?")
        config_options.each do |key, value|
          config_file.set(key, value)
        end
        config_file.write(force: true)
        puts "Configuration saved successfully @ #{config_file.full_path}"
      end
    end
  end
end
