# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start(args)
      prompt = TTY::Prompt.new

      options = args.flat_map { |arg| arg.split(" ") }
      puts "options: #{options}"

      app_name = options[0] || prompt.ask("What is the name of your application?", required: true)

      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets], default: default_assets(options))
      styling_choices = [
        {name: "Bootstrap", value: "bootstrap"},
        {name: "Tailwind CSS", value: "tailwind"},
        {name: "Bulma", value: "bulma"},
        {name: "PostCSS", value: "postcss"},
        {name: "SASS", value: "sass"}
      ]
      styling = prompt.select("How would you like to manage styling?", styling_choices, default: default_styling(options))

      database = prompt.select("Which database would you like to use?",
        %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc],
        default: default_database(options))

      Command.new(app_name: app_name, assets: assets, styling: styling, database: database).run
    end

    def default_assets(options)
      options.include?("sprockets") ? "sprockets" : "propshaft"
    end

    def default_styling(options)
      if options.include?("tailwind")
        "tailwind"
      elsif options.include?("bulma")
        "bulma"
      elsif options.include?("postcss")
        "postcss"
      elsif options.include?("sass")
        "sass"
      else
        "bootstrap"
      end
    end

    def default_database(options)
      if options.include?("postgresql")
        "postgresql"
      elsif options.include?("mysql")
        "mysql"
      elsif options.include?("trilogy")
        "trilogy"
      elsif options.include?("oracle")
        "oracle"
      elsif options.include?("sqlserver")
        "sqlserver"
      elsif options.include?("jdbcmysql")
        "jdbcmysql"
      elsif options.include?("jdbcsqlite3")
        "jdbcsqlite3"
      elsif options.include?("jdbcpostgresql")
        "jdbcpostgresql"
      elsif options.include?("jdbc")
        "jdbc"
      else
        "sqlite3"
      end
    end
  end
end
