# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aca_session',
  :secret      => '4cdd35ee9ad2cf188532fe82161a3f2f064af68926ece2d7da9d41fefcce6ceaeaf072d6af1bb1bda4d3ad0a851a5dfa9fa095ab1a3acfc4cef3b25e3a06bd54'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
