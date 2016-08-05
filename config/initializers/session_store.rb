# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_chat_session', domain: {
  production: '.sven.remote',
  development: '.sven.local'
}.fetch(Rails.env.to_sym, :all)
