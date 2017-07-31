module OmniAuth
  module Strategies
    class Hanami
      include OmniAuth::Strategy

      option :auth_key, ->(params) { params.fetch('user', {})['email'] }
      option :password_key, ->(params) { params.fetch('user', {})['password'] }
      option :encryption, :bcrypt
      option :interactor

      def callback_phase
        return fail!(:invalid_credentials) unless identity
        super
      end

      private

      uid do
        identity
      end

      def identity
        return @identity if @identity

        login = options.fetch(:auth_key).(request.params)
        password = options.fetch(:password_key).(request.params)
        result = interactor.new(login, password).call

        if result.success?
          @identity = result.user
        else
          @identity = nil
        end
      end

      def interactor
        options.fetch(:interactor)
      end

      def model
        options.fetch(:model)
      end
    end
  end
end
