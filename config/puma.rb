# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
# Heroku recommends setting min = max because apps can consume all the resources on its dyno
max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
min_threads_count = ENV.fetch("RAILS_MIN_THREADS", max_threads_count)
threads min_threads_count, max_threads_count

env = ENV.fetch("RAILS_ENV", "development")

# Specifies that the worker count should equal the number of processors in production.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
if env == "production"
  require "concurrent-ruby"
  # https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#process-count-value
  # recommends 1-2 workers for standard-1x dynos
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY", 2))
  workers worker_count if worker_count > 1
end

# Specifies the `environment` that Puma will run in.
environment env

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
worker_timeout 3600 if env == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT", 3000)

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart
