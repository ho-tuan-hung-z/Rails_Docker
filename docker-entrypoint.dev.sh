#!/bin/sh
set -x

bundle check || bundle install

RAILS_PORT=8080

if [ -n "$PORT" ]; then
  RAILS_PORT=$PORT
fi

# create db if not exist
bundle exec rails db:create

# migration
bundle exec rails db:migrate

# Remove a potentially pre-existing server.pid for Rails.
if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

bundle exec rails s -p $RAILS_PORT -b 0.0.0.0
