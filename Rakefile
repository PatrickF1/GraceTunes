# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake/testtask'

Rails.application.load_tasks

# For CircleCI integration (see https://github.com/circleci/minitest-ci#readme)
Rake::TestTask.new do |t|
  t.pattern = "test/test_*.rb"
end
task :default => :test