# frozen_string_literal: true

require "yaml"
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

    def write(force: false, output: nil)
      if output
        output.write(@config.to_h.to_yaml)
      else
        @config.write(force: force)
      end
    end

    def full_path
      File.join(@config.location_paths[0] + "/" + @config.filename + @config.extname)
    end

    def read
      @config.read if exist?
      @config.to_h
    end
  end
end
