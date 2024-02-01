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
gem 'rack-timeout'
gem 'rails', '7.1'
gem 'sass-rails', '>= 5' # Use SCSS for stylesheets
gem 'sdoc', group: :doc # bundle exec rake doc:rails generates the API under doc/api.
gem 'turbolinks'
gem "terser", "~> 1.1"
gem 'puma'
gem 'will_paginate'

group :development, :test do
  gem 'byebug' # Call 'byebug' anywhere to get a debugger console
end

group :test do
  gem 'rails-controller-testing'
  gem 'minitest-ci'
end

group :development do
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'spring' # keeps the app running in the background so you don't need to keep rebotting it
  gem 'spring-watcher-listen'
  gem 'web-console', '>= 4.2.0'
  gem 'solargraph' # ruby language server, need a plugin for editor/IDE to make sure of it
  # these gems are used to export all songs as PDF in a rake task that is run locally
  gem 'wicked_pdf'
  gem 'wkhtmltopdf-binary'
end
