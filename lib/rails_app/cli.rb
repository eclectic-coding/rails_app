# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start
      prompt = TTY::Prompt.new

      app_name = prompt.ask("What is the name of your application?", required: true)
      spring = prompt.yes?("Would you like to skip-spring?")
      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets])
      bundling = prompt.select("Choose your javascript bundling?", %w[importmap esbuild])
      styling = prompt.select("Choose your CSS framework?", %w[bootstrap tailwind none])
      testing = prompt.select("What testing framework would you like to use?", %w[minitest rspec none])

      Dir.chdir("#{Dir.home}/Desktop") do
        Command.new(app_name: app_name, spring: spring, assets: assets, bundling: bundling, styling: styling, testing: testing).run
      end
    end
  end
end
