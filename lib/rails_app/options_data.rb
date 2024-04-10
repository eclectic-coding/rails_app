# frozen_string_literal: true

module RailsApp
  class OptionsData
    attr_reader :options

    def initialize(args)
      @options = args
    end

    def app_name
      @options[0]
    end

    def default_assets
      # puts "@options: #{@options.include?("sprockets")}"

      @options.include?("sprockets") ? "sprockets" : "propshaft"
    end

    def default_bundling
      if @options.include?("esbuild")
        "esbuild"
      elsif @options.include?("importmaps")
        "importmaps"
      else
        "esbuild"
      end
    end

    def default_styling
      if @options.any? { |option| option.end_with?("tailwind") }
        "tailwind".strip
      elsif @options.any? { |option| option.end_with?("bulma") }
        "bulma".strip
      elsif @options.any? { |option| option.end_with?("postcss") }
        "postcss".strip
      elsif @options.any? { |option| option.end_with?("sass") }
        "sass"
      elsif @options.any? { |option| option.end_with?("bootstrap") }
        "bootstrap"
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

    def default_action_mailer
      @options.include?("skip_action_mailer")
    end

    def default_action_mailbox
      @options.include?("skip_action_mailbox")
    end

    def default_action_text
      @options.include?("skip_action_text")
    end

    def default_action_storage
      @options.include?("skip_action_storage")
    end

    def default_action_cable
      @options.include?("skip_action_cable")
    end
  end
end
