require 'bundler/inline'
require_relative 'test_app'

use Rack::Session::Cookie, secret: 'xyz'
use OmniAuth::Builder do
  provider :hanami
end
run HanamiTestApp
