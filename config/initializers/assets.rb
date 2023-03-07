# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w(
  email.*
  admin.*
  operator.*
  print.*
  platform.*
  ppa.*
  ppa/admin.*
  mailer.*
  ticket.*
  transparency.*
  errors.*
  views/*
  ckeditor/*
  modules/accessibility.scss
  components/multi_dependent_select.js
  modules/switchery.js
)
