require_relative '../test_helper'

class UserTest < Minitest::Test

	def test_initialization
		user = Arangodm::User.new(
			username: 'root',
			password: 'kaoskaos'
		)

		server = Arangodm::Server.new

		api = Arangodm::Api.new(
			server: server
		)

		api.authenticate(user: user)

		puts api.db_name
	end
end