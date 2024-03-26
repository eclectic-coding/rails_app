# frozen_string_literal: true

require_relative "rails_app/version"

module RailsApp
  autoload :App, "rails_app/rails_app"
  autoload :CLI, "rails_app/cli"
  autoload :Error, "rails_app/error"
end
