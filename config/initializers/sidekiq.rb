# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }

  schedule_file = 'config/schedule.yml'
  if File.exist?(schedule_file)
    schedule_data = YAML.load_file(schedule_file)
    Sidekiq::Cron::Job.load_from_hash(schedule_data, overwrite: true)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end
