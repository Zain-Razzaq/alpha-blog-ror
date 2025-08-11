Rails.application.config.session_store :cookie_store,
  key: 'session_key',
  same_site: :lax, # or :none if using HTTPS
  secure: false
