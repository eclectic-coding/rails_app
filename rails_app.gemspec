# frozen_string_literal: true

require_relative "lib/rails_app/version"

Gem::Specification.new do |spec|
  spec.name = "rails_app"
  spec.version = RailsApp::VERSION
  spec.authors = ["Chuck Smith"]
  spec.email = ["chuck@eclecticsaddlebag.com"]

  spec.summary = "Bootstrap a new customized Rails application with a better development experience."
  spec.description = "Bootstrap a new customized Rails application with a better development experience."
  spec.homepage = "https://github.com/eclectic-coding/rails_app"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.4"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eclectic-coding/rails_app"
  spec.metadata["changelog_uri"] = "https://github.com/eclectic-coding/rails_app/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["rails_app"]
  spec.require_paths = ["lib"]

  spec.add_dependency "bootsnap", "~> 1.18", ">= 1.18.3" # used by rails new
  spec.add_dependency "thor", "~> 1.3", ">= 1.3.1"
  spec.add_dependency "tty-prompt", "~> 0.23.1"
end
