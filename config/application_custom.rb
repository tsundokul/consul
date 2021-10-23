module Consul
  class Application < Rails::Application
    config.deploy = config_for(:deploy)
    config.action_view.cache_template_loading = false

    config.i18n.default_locale = :ro
    config.i18n.available_locales = %w[ro en]
  end
end
