module Arangodm
  # @attr [String] username
  # @attr [String] password
  # @attr_reader [String] jwt
  class User
    include ActiveAttr::Default

    attribute :username
    attribute :password

    attr_reader :jwt

    # Authenticates the user
    #
    # @param [Arangodm::Api] api that it can authenticate through that
    # @return [String] jwt digest of the authentication
    def authenticate(api)
      return jwt if jwt
      result = api.post(
        address: '_open/auth',
        body: { username: username, password: password },
        authorized: false
      )
      @jwt = result[:jwt]
    end
  end
end
