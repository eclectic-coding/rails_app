module RailsApp
  class Command
    attr_reader :app_name, :assets, :styling, :database

    def initialize(app_name, args)
      # puts "args: #{args}"
      @app_name = app_name
      @assets = args[:assets]
      @bundling = args[:bundling]
      @styling = args[:styling]
      @database = args[:database]
      @skip_spring = args[:skip_spring]
      @skip_action_mailer = args[:action_mailer]
      @skip_action_mailbox = args[:action_mailbox]
      @skip_action_text = args[:action_text]
      @skip_action_storage = args[:action_storage]
      @skip_action_cable = args[:action_cable]
    end

    def template
      if @bundling == "esbuild"
        File.join(__dir__, "template", "template_esbuild.rb")
      else
        File.join(__dir__, "template", "template_importmaps.rb")
      end
    end

    def run
      command = "rails new #{@app_name} --no-rc #{skip_spring} #{skip_action_mailer} #{skip_action_mailbox} #{skip_action_text} #{skip_action_text} #{skip_action_cable} #{database_adapter} #{asset_management} #{javascript_bundling} #{styling_framework} #{testing_framework} -m #{template}"
      command.squeeze!(" ")
      puts command
      # system(command)
    end

    def skip_spring
      "--skip-spring" if @skip_spring == true
    end

    def skip_action_mailer
      "--skip-action-mailer" if @skip_action_mailer == true
    end

    def skip_action_mailbox
      "--skip-action-mailbox" if @skip_action_mailbox == true
    end

    def skip_action_text
      "--skip-action-text" if @skip_action_text == true
    end

    def skip_action_storage
      "--skip-active-storage" if @skip_action_storage == true
    end

    def skip_action_cable
      "--skip-action-cable" if @skip_action_cable == true
    end

    def database_adapter
      "-d #{@database}" unless database == "sqlite3"
    end

    def javascript_bundling
      if @bundling != "importmap"
        "-j #{@bundling}"
      end
    end

    def asset_management
      "-a propshaft" unless assets == "sprockets"
    end

    def styling_framework
      return if @bundling == "importmap"

      "--css #{@styling}"
    end

    def testing_framework
      "-T"
    end
  end
end
