# frozen_string_literal: true

# Configure acceptable Firebase project IDs for Bearer token verification.
# Set FIREBASE_PROJECT_IDS to a comma-separated list of allowed project IDs.

FirebaseIdToken.configure do |config|
  allowed = ENV.fetch('FIREBASE_PROJECT_IDS', '').split(',').map { |s| s.strip.presence }.compact
  # If none specified, default to ENV['FIREBASE_PROJECT_ID'] if present
  allowed = [ENV['FIREBASE_PROJECT_ID']] if allowed.empty? && ENV['FIREBASE_PROJECT_ID']
  config.project_ids = allowed if allowed.any?
end


