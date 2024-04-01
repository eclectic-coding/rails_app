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
      command = "rails new #{@app_name} --no-rc #{skip_spring} #{asset_management} #{javascript_bundling} #{styling_framework} #{testing_framework} -m #{template}"
      puts command
      system(command)
    end

    def skip_spring
      "--skip-spring"
    end

    def javascript_bundling
      "-j esbuild"
    end

    def asset_management
      "-a propshaft" unless assets == "sprockets"
    end

    def styling_framework
      if @bundling == "esbuild" && @styling != "none"
        "--css #{@styling}"
      end
    end

    def testing_framework
      "-T"
    end
  end
end
