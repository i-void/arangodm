require_relative '../test_helper'

class UserTest < Minitest::Test

	def test_initialization
		user = Arangodm::User.new(username: "3")
		valid = user.valid?
		puts user.errors.messages
		assert valid
	end
end