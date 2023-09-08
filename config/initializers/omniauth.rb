Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    hd: %w(gpmail.org acts2.network) # restrict logins to only gpmail.org or acts2.network accounts
  }
end
