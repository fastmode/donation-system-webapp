# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

require_relative 'lib/deploy/deployer'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task(:default).clear
task default: %i[spec rubocop]

namespace :deploy do
  desc 'Upload assets to AWS S3 and deploy to Heroku (production)'
  task :production { Deploy::Deployer.production }

  desc 'Upload assets to AWS S3 and deploy to Heroku (staging)'
  task :staging { Deploy::Deployer.staging }
end
