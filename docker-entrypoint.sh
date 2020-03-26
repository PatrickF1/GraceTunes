#!/usr/bin/env sh

# Forward env variables, fail on errors
set -aeu

cp -r /src/* .

bundle install
bundle exec rails db:setup
bundle exec rails db:fixtures:load
bundle exec rails server -b 0.0.0.0
