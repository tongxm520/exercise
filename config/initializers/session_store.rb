# Be sure to restart your server when you modify this file.

Exercise::Application.config.session_store ActionDispatch::Session::CacheStore, 
:expire_after => 1.month

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Exercise::Application.config.session_store :active_record_store

# memcache defaults, environments may override these settings



