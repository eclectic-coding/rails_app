# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start(args)
      # puts "args: #{args}"
      prompt = TTY::Prompt.new
      options_data = OptionsData.new(args)
      config_file = ConfigFile.new

      # TODO: add back in option data to set defaults for menu and bypass use config question
      app_name = options_data.app_name || prompt.ask("What is the name of your application?", required: true)

      # Read from existing configuration and ask the user if they want to use it
      config_options = config_file.read

      if config_options && prompt.yes?("Do you want to use this configuration? #{config_options}")
        create_app(app_name, config_options) # standard:disable Style/IdenticalConditionalBranches
      else
        # not using config display menu to user
        config_options = menu(prompt)

        # Ask the user if they wish to save their configuration
        if prompt.yes?("Do you wish to save your configuration?")
          # Iterate over the hash and set the configuration
          config_options.each do |key, value|
            config_file.set(key, value)
          end
          config_file.write(force: true)
          puts "Configuration saved successfully @ #{config_file.full_path}"
        end

        create_app(app_name, config_options) # standard:disable Style/IdenticalConditionalBranches
      end
    end

    def self.menu(prompt)
      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets])
      styling = prompt.select("How would you like to manage styling?", %w[bootstrap tailwind bulma postcss sass])
      database = prompt.select("Which database would you like to use?", %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc])
      action_mailer = prompt.yes?("Would you like to SKIP Action Mailer?") do |q|
        q.default false
        q.positive "Yes"
        q.negative "No"
      end
      action_mailbox = prompt.yes?("Would you like to SKIP Action Mailbox?") do |q|
        q.default false
        q.positive "Yes"
        q.negative "No"
      end
      action_text = prompt.yes?("Would you like to SKIP Action Text?") do |q|
        q.default false
        q.positive "Yes"
        q.negative "No"
      end
      action_storage = prompt.yes?("Would you like to SKIP Active Storage?") do |q|
        q.default false
        q.positive "Yes"
        q.negative "No"
      end
      action_cable = prompt.yes?("Would you like to SKIP Active Cable?") do |q|
        q.default false
        q.positive "Yes"
        q.negative "No"
      end

      {assets: assets, styling: styling, database: database, action_mailer: action_mailer, action_mailbox: action_mailbox,
       action_text: action_text, action_storage: action_storage, action_cable: action_cable}
    end

    def self.create_app(app_name, args)
      Command.new(app_name, args).run
    end
  end
end
