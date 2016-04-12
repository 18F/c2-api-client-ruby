# use local 'lib' dir in include path
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'c2'
require 'json'
require 'pp'
require 'dotenv'

Dotenv.load

RSpec.configure do |config|
  config.color = true
  config.order = 'random'
end

# assumes ID and SECRET set in env vars
OAUTH_KEY    = ENV['OAUTH_KEY']
OAUTH_SECRET = ENV['OAUTH_SECRET']
if !OAUTH_KEY or !OAUTH_SECRET
  abort("Must set OAUTH_KEY and OAUTH_SECRET env vars -- did you create a .env file?")
end

def get_c2_client
  C2::Client.new(
    oauth_key: OAUTH_KEY,
    oauth_secret: OAUTH_SECRET,
    host: ENV.fetch('C2_HOST', 'http://localhost:3000'),
    debug: ENV.fetch('C2_DEBUG', false)
  )
end
