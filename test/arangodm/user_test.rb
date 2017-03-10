require_relative '../test_helper'

class UserTest < Minitest::Test

	def test_initialization
		user = Arangodm::User.new(
			username: 'root',
			password: '12345678'
		)

		server = Arangodm::Server.new
		server.autheticate(user: user)

		puts server.db.name
	end
end