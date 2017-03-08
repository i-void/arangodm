require_relative '../test_helper'

class UserTest < Minitest::Test

	def test_initialization
		user = Arangodm::User.new(
			username: 'root',
			password: '12345678'
		)

		server = Arangodm::Server.new

		api = Arangodm::Api.new(
			server: server
		)

		api.authenticate(user: user)

		puts api.jwt
	end
end