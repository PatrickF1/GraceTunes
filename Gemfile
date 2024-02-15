# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'audited'
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'diffy'
gem 'font-awesome-rails'
gem 'jbuilder' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jquery-datatables-rails', '~> 3.4.0' # Use datatables for rendering and searching songs
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'js_cookie_rails' # Use js-cookie to handle cookies
gem 'json-schema' # validate JSON data structures using json-schema
gem 'normalize-rails'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'pg'
gem 'pg_search'
gem 'puma'
gem 'rack-timeout'
gem 'rails', '7.1'
gem 'sass-rails', '>= 5' # Use SCSS for stylesheets
gem 'sdoc', group: :doc # bundle exec rake doc:rails generates the API under doc/api.
gem 'terser', "~> 1.1" # JS minifier
gem 'turbolinks'
gem 'will_paginate'

group :development, :test do
  gem "debug", ">= 1.0.0" # Call 'debugger' anywhere to get a debugger console
end

group :test do
  gem 'minitest-ci'
  gem 'rails-controller-testing'
end

group :development do
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'solargraph' # ruby language server, need a plugin for editor/IDE to make use of it
  gem 'spring' # keeps the app running in the background so you don't need to keep rebooting it
  gem 'spring-watcher-listen'
  gem 'web-console', '>= 4.2.0'
  # these gems are used to export all songs as PDF in a rake task that is run locally
  gem 'wicked_pdf'
  gem 'wkhtmltopdf-binary'
end
