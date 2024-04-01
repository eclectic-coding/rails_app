# frozen_string_literal: true

def add_template_to_source_path
  [__dir__]
end

def add_gems
  gsub_file "Gemfile", /^ruby ['"].*['"]/, "ruby file: '.ruby-version'"
end

# Main setup
add_template_to_source_path

add_gems

