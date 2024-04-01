# frozen_string_literal: true

module RailsApp
  class Command
    attr_reader :app_name, :bundling, :assets

    def initialize(app_name:, assets:, styling:)
      @app_name = app_name
      @assets = assets
      @styling = styling
    end

    def template
      File.join(__dir__, "template", "template.rb")
    end

    def run
      command = "rails new #{@app_name} #{asset_management} #{javascript_bundling} #{styling_framework} #{testing_framework} --no-rc -m #{template} #{skip_spring}"
      puts command
      system(command)
    end

    def skip_spring
      "--skip-spring" unless @spring == "yes"
    end

    def javascript_bundling
      "-j #{bundling}" unless bundling == "importmap"
    end

    def asset_management
      "-a propshaft" unless assets == "sprockets"
    end

    def styling_framework
      if @bundling == "esbuild" && @styling != "none"
        puts "HERE: #{@styling}"
        "--css #{@styling}"
      end
    end

    def testing_framework
      "-T" unless @testing == "minitest"
    end
  end
end
