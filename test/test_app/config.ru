require 'warden'
require_relative 'test_app'

use Rack::Session::Cookie, secret: 'xyz'
use Warden::Manager
use OmniAuth::Builder do
  provider :hanami, interactor: Interactors::FindUserForAuth
end
run HanamiTestApp
