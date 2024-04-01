# frozen_string_literal: true

require "tty-prompt"

module RailsApp
  class CLI
    def self.start
      prompt = TTY::Prompt.new

      app_name = prompt.ask("What is the name of your application?", required: true)
      assets = prompt.select("How would you like to manage assets?", %w[propshaft sprockets])

      Dir.chdir("#{Dir.home}/Desktop") do
        Command.new(app_name: app_name, assets: assets).run
      end
    end
  end
end
