# frozen_string_literal: true

module RailsApp
  class App
    def self.rails_app(args)
      RailsApp::CLI.start(args)
    end
  end
end
