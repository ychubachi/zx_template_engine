# config/enviroments/development.rb
# See http://guides.rubyonrails.org/configuring.html
ZxTemplateEngine::Application.configure do
  Rails.logger = Log4r::Logger.new('zxt')
  Rails.logger.outputters = Log4r::Outputter.stdout
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.assets.compress = false
  config.assets.debug = true
end
