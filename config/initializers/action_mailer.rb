Rails.application.config.action_mailer.perform_deliveries = true

Rails.application.config.action_mailer.raise_delivery_errors = true

Rails.application.config.action_mailer.smtp_settings = {
  :address              => ENV['MAIL_ADDRESS'],
  :from                 => ENV['MAIL_FROM'],
  :port                 => ENV['MAIL_PORT'],
  :domain               => ENV['MAIL_DOMAIN'],
  :user_name            => ENV['MAIL_USER_NAME'],
  :password             => ENV['MAIL_PASSWORD'],
  :authentication       => :login,
  :enable_starttls_auto => (ENV['MAIL_ENABLE_STARTTLS_AUTO'] == 'false' ? false : true),
  :openssl_verify_mode  => 'none'
}

Rails.application.config.action_mailer.default_url_options = {
  :host => ENV['DEFAULT_HOST'],
  :protocol => ENV['DEFAULT_PROTOCOL'] || 'http'
}

# @see https://www.mailgun.com/blog/tips-tricks-avoiding-gmail-spam-filtering-when-using-ruby-on-rails-action-mailer
#   for more infor about "Message-ID". It avoids GMail filtering as SPAM.
Rails.application.config.action_mailer.default_options = {
  :from => ENV['MAIL_FROM'],
  "Message-ID" => ->(_) { "<#{SecureRandom.uuid}@#{ENV['MAIL_DOMAIN']}>" }
}

Rails.application.config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"
