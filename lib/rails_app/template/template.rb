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

def config_generators
  inject_into_file "config/application.rb", "    config.generators.helper = false", after: "config.generators.system_tests = nil\n"
  inject_into_file "config/application.rb", "    config.generators.stylesheets = false\n\n", after: "config.generators.helper = false\n"
end

def add_javascript
  run "yarn add chokidar -D"
  run "yarn add esbuild-rails"

  run "echo | node -v | cut -c 2- > .node-version"
end

def add_esbuild_script
  build_script = "node esbuild.config.mjs"

  case `npx -v`.to_f
  when 7.1...8.0
    run %(npm set-script build "#{build_script}")
    run %(yarn build)
  when (8.0..)
    run %(npm pkg set scripts.build="#{build_script}")
    run %(yarn build)
  else
    say %(Add "scripts": { "build": "#{build_script}" } to your package.json), :green
  end
end

# Main setup
add_template_to_source_path

add_gems

after_bundle do
  config_generators
  add_javascript

  say
  say "Rails app successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "  cd #{app_name}"
end

