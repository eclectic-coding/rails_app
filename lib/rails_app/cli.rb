# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start
      prompt = TTY::Prompt.new

      app_name = prompt.ask("What is the name of your application?", required: true)
      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets])
      styling_choices = [
        {name: "Bootstrap", value: "bootstrap"},
        {name: "Tailwind CSS", value: "tailwind"},
        {name: "Bulma", value: "bulma"},
        {name: "PostCSS", value: "postcss"},
        {name: "SASS", value: "sass"}
      ]
      styling = prompt.select("How would you like to manage styling?", styling_choices)
      # database = prompt.select("Which database would you like to use?", %w[postgresql sqlite3 mysql trilogy oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc])

      Command.new(app_name: app_name, assets: assets, styling: styling).run
    end
  end
end
