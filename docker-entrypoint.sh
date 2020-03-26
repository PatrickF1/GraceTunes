#!/usr/bin/env bash

# Forward env variables, fail on errors
set -aeu

cp -r /src/* .

[[ -f .env ]] && . .env

bundle install
bundle exec rails db:setup
bundle exec rails db:fixtures:load
bundle exec rails server -b 0.0.0.0
