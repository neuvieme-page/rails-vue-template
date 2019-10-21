gem 'pg', '~> 0.21'
gem 'bundler', '~> 2.0.2'
gem 'devise'
gem 'annotate'
gem 'rails_admin', '~> 2.0'

gem_group :development, :test do
  gem 'rails-erd', group: :develop
end

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


