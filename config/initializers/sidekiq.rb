# start all queues in development & give namespace
# Sidekiq.configure_server do |config|
#   config.options[:queues] = %w(default)
#   config.redis = {:namespace => 'kuvera', url: 'redis://localhost:6379'}
# end
Sidekiq.configure_client do |config|
  config.redis = { namespace: 'kuvera' }
end
