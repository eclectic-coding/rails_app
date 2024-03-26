# frozen_string_literal: true

require_relative "lib/rails_app/version"

Gem::Specification.new do |spec|
  spec.name = "rails_app"
  spec.version = RailsApp::VERSION
  spec.authors = ["Chuck Smith"]
  spec.email = ["chuck@eclecticsaddlebag.com"]

  spec.summary = "Write a short summary, because RubyGems requires one."
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://github.com/eclectic-coding/rails_app"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

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
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bootsnap" # used by rails new
end
