# frozen_string_literal: true

require_relative "rails_app/version"

module RailsApp
  autoload :App, "rails_app/rails_app"
  autoload :CLI, "rails_app/cli"
  autoload :Command, "rails_app/command"
  autoload :OptionsData, "rails_app/options_data"
  autoload :ConfigFile, "rails_app/config_file"
  autoload :Error, "rails_app/error"
end
