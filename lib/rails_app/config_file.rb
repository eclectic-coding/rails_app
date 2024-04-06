# frozen_string_literal: true

require "tty-config"

module RailsApp
  class ConfigFile
    def initialize
      @config = TTY::Config.new
      @config.append_path(Dir.home)
      @config.filename = "rails_app-config"
      @config.extname = ".yml"
    end

    def exist?
      @config.exist?
    end

    def set(key, value)
      @config.set(key, value: value)
    end

    def write(force: false)
      @config.write(force: force)
    end

    def full_path
      File.join(@config.location_paths[0] + "/" + @config.filename + @config.extname)
    end

    def read
      @config.read if exist?
      @config.to_h || {}
    end
  end
end
