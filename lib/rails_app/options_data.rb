# frozen_string_literal: true

module RailsApp
  class OptionsData
    attr_reader :options

    def initialize(args)
      @options = args.flat_map { |arg| arg.split(" ") }
    end

    def app_name
      @options[0]
    end

    def default_assets
      @options.include?("sprockets") ? "sprockets" : "propshaft"
    end

    def default_styling
      if @options.include?("tailwind")
        "tailwind"
      elsif @options.include?("bulma")
        "bulma"
      elsif @options.include?("postcss")
        "postcss"
      elsif @options.include?("sass")
        "sass"
      else
        "bootstrap"
      end
    end

    def default_database
      if @options.include?("postgresql")
        "postgresql"
      elsif @options.include?("mysql")
        "mysql"
      elsif @options.include?("trilogy")
        "trilogy"
      elsif @options.include?("oracle")
        "oracle"
      elsif @options.include?("sqlserver")
        "sqlserver"
      elsif @options.include?("jdbcmysql")
        "jdbcmysql"
      elsif @options.include?("jdbcsqlite3")
        "jdbcsqlite3"
      elsif @options.include?("jdbcpostgresql")
        "jdbcpostgresql"
      elsif @options.include?("jdbc")
        "jdbc"
      else
        "sqlite3"
      end
    end
  end
end
