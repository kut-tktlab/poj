Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.middleware.delete Rack::Lock

  config.generators do |g|
    g.assets false
    g.helper false
    g.test_framework :rspec, view_specs: false, helper_specs: false, fixture: true
  end

  config.web_console.whitelisted_ips = %w( 0.0.0.0/0 ::/0 )
end
