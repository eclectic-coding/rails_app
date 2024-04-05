module RailsApp
  class Command
    attr_reader :app_name, :assets, :styling, :database

    def initialize(app_name:, assets:, styling:, database:)
      @app_name = app_name
      @assets = assets
      @styling = styling
      @database = database
    end

    def template
      File.join(__dir__, "template", "template.rb")
    end

    def run
      command = "rails new #{@app_name} --no-rc #{skip_spring} #{database_adapter} #{asset_management} #{javascript_bundling} #{styling_framework} #{testing_framework} -m #{template}"
      command.squeeze!(" ")
      puts command
      system(command)
    end

    def skip_spring
      "--skip-spring"
    end

    def database_adapter
      "-d #{@database}" unless database == "sqlite3"
    end

    def javascript_bundling
      "-j esbuild"
    end

    def asset_management
      "-a propshaft" unless assets == "sprockets"
    end

    def styling_framework
      "--css #{@styling}"
    end

    def testing_framework
      "-T"
    end
  end
end
