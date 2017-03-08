module Arangodm

  # @attr [String] username
  # @attr [String] password
	class User
    include ActiveAttr::Default

    attribute :username
    attribute :password

    # Authenticates the user
    #
    # @param [Arangodm::Api] api that it can authenticate through that
    # @return [String] jwt digest of the authentication
    def authenticate(api)
      result = api.post(
        address: '_open/auth',
        body: {username: username, password: password},
        authorized: false
      )
      result['jwt']
    end

	end
end