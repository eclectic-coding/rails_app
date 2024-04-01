# frozen_string_literal: true

def add_template_to_source_path
  source_paths.unshift(File.expand_path(File.join(__dir__)))
end

def add_gems
  gsub_file "Gemfile", /^ruby ['"].*['"]/, "ruby file: '.ruby-version'"

  inject_into_file "Gemfile", after: "ruby file: '.ruby-version'" do
    "\neval_gemfile 'config/gems/app.rb'"
  end

  inject_into_file "Gemfile", after: "eval_gemfile 'config/gems/app.rb'" do
    "\neval_gemfile 'config/gems/rspec_gemfile.rb'"
  end

  directory "config", "config", force: true
end

# Main setup
add_template_to_source_path

add_gems

