gem 'bundler', '~> 2.0.2'
gem 'annotate'

gem_group :development, :test do
  gem 'rails-erd', group: :develop
end

# Homepage

route "root to: 'application#home'"
APPLICATION_CONTROLLER = <<-CODE
class ApplicationController < ActionController::Base
  def home
  end
end
CODE

APPLICATION_HOME_VIEW = <<-CODE

CODE

run "mkdir app/views/application"

create_file "app/controllers/application_controller.rb", APPLICATION_CONTROLLER, force: true
create_file "app/views/application/home.html.erb", APPLICATION_HOME_VIEW, force: true

# Devise

gem 'devise'
generate("devise:install")
generate(:devise, "User")
generate(:devise, "Admin")
generate("devise:views")

# Rails admin

gem 'rails_admin', '~> 2.0'
generate("rails_admin:install")

# Database

gem 'pg', '~> 0.21'
DB_CONFIG = <<-CODE
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: #{@app_name}_dev

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: #{@app_name}_test

production:
  <<: *default
  database: #{@app_name}_prod
  username: admin
  password: <%= ENV['HEY_DATABASE_PASSWORD'] %>
CODE

create_file "config/database.yml", DB_CONFIG, force: true

# layout

APPLICATION_LAYOUT = <<-CODE
<!DOCTYPE html>
<html>
  <head>
    <title>VueRailsTest</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= javascript_pack_tag 'application' %> 
    <%= stylesheet_pack_tag 'application' %> 
  </head>

  <body>
    <%= yield %>
  </body>
</html>
CODE

create_file "app/views/layouts/application.html.erb", APPLICATION_LAYOUT, force: true


# vue

after_bundle do

  run "bundle exec rails webpacker:install:vue"

  APPLICATION_PACK_VUE = <<-CODE
  import Vue from 'vue'
  import App from '../app.vue'

  document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
      render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)

    console.log(app)
  })
  CODE

  run "rm app/javascript/packs/hello_vue.js"
  create_file "app/javascript/packs/application.js", APPLICATION_PACK_VUE, force: true



  APP_VUE = <<-CODE
  <template>
    <div id='app'>
      <p>{{ message }}</p>
    </div>
  </template>

  <script>
    export default {
      data: function () {
        return {
          message: "Hello Vue"
        }
      }
    }
  </script>

  <style scoped>
    p {
      font-size: 2em;
      text-align: center;
    }
  </style>
  CODE

  create_file "app/javascript/app.vue", APP_VUE, force: true


  # Migration

  rails_command "db:drop"
  rails_command "db:create"
  rails_command "db:migrate"

end