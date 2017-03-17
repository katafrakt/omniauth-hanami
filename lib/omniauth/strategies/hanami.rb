module OmniAuth
  module Strategies
    class Hanami
      include OmniAuth::Strategy

      option :auth_key, ->(params) { params['user']['email'] }
      option :password_key, ->(params) { params['user']['password'] }
      option :repository, nil
      option :encryption, :bcrypt
      option :repository_method, :find_by_credentials

      def callback_phase
        return fail!(:invalid_credentials) unless identity
        #env['omniauth.auth'] = identity.to_hash
        super
      end

      private

      uid do
        identity
      end

      def identity
        return @identity if @identity
        method = options.fetch(:repository_method)
        conditions = { auth_key: options.fetch(:auth_key).(request.params) }
        password = options.fetch(:password_key).(request.params)
        @identity = repository.new.public_send(method, conditions, password)
      end

      def repository
        options.fetch(:repository)
      end

      def model
        options.fetch(:model)
      end
    end
  end
end
