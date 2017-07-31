require 'hanami/router'
require 'omniauth/hanami'
require 'hanami/controller'
require 'hanami/interactor'

class Credentials < Hanami::Entity
end

class User < Hanami::Entity
end

class CredentialsRepository < Hanami::Repository
  associations do
    belongs_to :user
  end
end

class UserRepository < Hanami::Repository
  associations do
    has_many :credentials
  end

  def find_by_email(email)
    root.where(email: email).map_to(User).one
  end
end

Hanami::Model.load!

module Controllers
  module Session
    class Create
      include Hanami::Action

      def auth_hash
        request.env['omniauth.auth']
      end

      def call(_params)
        if auth_hash.provider == 'hanami'
          user = auth_hash.uid
        else
          user = UserRepository.new.auth!(auth_hash)
        end

        warden.set_user user
        redirect_to '/'
      end

      def warden
        request.env['warden']
      end
    end
  end
end

module Interactors
  class FindUserForAuth
    include Hanami::Interactor

    expose :user

    def initialize(login, password)
      @login = login
      @password = password
    end

    def call
      user = UserRepository.new.find_by_email(@login)
      if user && user.crypted_password && SCrypt::Password.new(user.crypted_password) == @password
        @user = user
      else
        fail!
      end
    end
  end
end

HanamiTestApp = Hanami::Router.new(namespace: Controllers) do
  get '/', to: ->(env) { [200, {}, ['Hello, World!']] }
  get '/auth/:provider/callback', to: 'session#create'
  post '/auth/:provider/callback', to: 'session#create'
end
