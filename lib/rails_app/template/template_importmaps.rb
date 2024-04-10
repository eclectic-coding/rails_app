# frozen_string_literal: true

require "fileutils"
require "shellwords"

puts "template: importmaps"
puts "options: #{options}"
puts "ENV: #{ENV["STYLING"]}"

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

def add_users
  generate "devise:install"

  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: "development"
  environment "config.action_mailer.default_url_options = { host: 'example.com' }", env: "test"

  generate :devise, "User", "admin:boolean"

  # Set admin default to false
  in_root do
    migration = Dir.glob("db/migrate/*").max_by { |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  gsub_file "config/initializers/devise.rb", / {2}# config.secret_key = .+/, "  config.secret_key = Rails.application.credentials.secret_key_base"
end

def dev_tools
  generate "annotate:install"

  inject_into_file "config/environments/development.rb", after: "Rails.application.configure do\n" do
    <<-CODE
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = false
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end\n
    CODE
  end
end

def add_static
  generate "controller static home"

  route "root to: 'static#home'"
end

def add_styling
  if ENV["STYLING"] == "bootstrap"
    run "bin/importmap pin bootstrap"
    directory "app_bootstrap_importmap", "app", force: true
    setup_importmap_bootstrap
  elsif ENV["STYLING"] == "tailwind"
    config_tailwind
  elsif ENV["STYLING"] == "bulma"
    directory "app_bulma", "app", force: true
  elsif ENV["STYLING"] == "postcss"
    directory "app_postcss", "app", force: true
  elsif ENV["STYLING"] == "sass"
    directory "app_sass", "app", force: true
  end
end

def setup_importmap_bootstrap
  # add gems
  inject_into_file "config/gems/app.rb", after: "gem \"devise\"\n" do
    <<-CODE
  gem "bootstrap", "~> 5.3"
  gem "sassc-rails", "~> 2.1"
    CODE
  end
  run "bundle install"

  # remove old stylesheet
end

def config_tailwind
  # run "yarn add flowbite postcss-import postcss-nested"
  #
  # copy_file "app_tailwind/tailwind.config.js", "tailwind.config.js", force: true
  # copy_file "app_tailwind/postcss.config.js", "postcss.config.js", force: true
  #
  # gsub_file "package.json", "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify", "tailwindcss --postcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"
end

def setup_rspec
  copy_file ".rspec", ".rspec"
  directory "spec", "spec", force: true
end

def copy_templates
  copy_file ".rubocop.yml", ".rubocop.yml"
  copy_file ".rubocop_todo.yml", ".rubocop_todo.yml"
  copy_file "Brewfile", "Brewfile"

  directory "bin", "bin", force: true

  gsub_file "config/environments/development.rb", / {2}# config.action_view.annotate_rendered_view_with_filenames = true/, "  config.action_view.annotate_rendered_view_with_filenames = true"
end

def database_setup
  rails_command("db:create")
  rails_command("db:migrate")
end

def command_available?(command)
  system("command -v #{command} >/dev/null 2>&1")
end

def run_setup
  # Install system dependencies if Homebrew is installed
  if command_available?("brew")
    system("brew bundle check --no-lock --no-upgrade") || system!("brew bundle --no-upgrade --no-lock")
  end
end

def add_binstubs
  run "bundle binstub rubocop"
  run "bundle binstub rspec-core" if options[:skip_test]
end

def lint_code
  run "bundle exec rubocop -a"
end

def initial_commit
  run "git init"
  run "git add . && git commit -m \"Initial_commit\""
end

# Main setup
add_template_to_source_path

add_gems

after_bundle do
  add_users
  dev_tools
  add_static
  add_styling
  setup_rspec
  copy_templates
  database_setup
  run_setup
  add_binstubs
  lint_code
  initial_commit

  say
  say "Rails app successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "  cd #{app_name}"
end
