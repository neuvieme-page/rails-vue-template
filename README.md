# rails-vue-template

## Features
- `rails-erd` generate graphic database scheme <a href="https://github.com/voormedia/rails-erd">See more</a>
- `pg` Database configuration setup for postgres to deploy on heroku
- `devise` Handle user authentification
- `annotate` Generate documentation for all models
- `rails_admin` Create a backoffice

## How to install

### Postgres

First you need to have the Postgres.
You can download the Postgres App <a href="https://postgresapp.com">here</a>.

To configure Rails with Postgress you need to install the `pg` gem and specify the config path to the postgres app location.
```
gem install pg -v 0.21.0 -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/12/bin/pg_config
```
> Here the command is specific to a MacOS configuration with the postgres version 12  
 


### Create the app

Simply run the command
```
rails new your_app -m https://neuvieme-page.github.io/rails-vue-template/template.rb
```

Then generate you database
```
rails db:create db:migrate
```

Finaly run your server
```
rails s
```