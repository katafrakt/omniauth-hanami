require 'hanami/router'
require 'omniauth/hanami'

HanamiTestApp = Hanami::Router.new do
  get '/', to: ->(env) { [200, {}, ['Hello, World!']] }
end
