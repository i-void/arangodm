require_relative '../test_helper'
require 'ostruct'

class DatabaseTest < Minitest::Test
	def setup
		Arangodm::Database.instance_variable_set(:'@list', nil)
		Arangodm::Database.instance_variable_set(:'@default', nil)
	end

	def test_db_must_be_added_to_multiton
		db_obj = Arangodm::Database.new(name: 'test', user: 'test_user', password: 'password')
		assert_equal Arangodm::Database.list['test'], db_obj
		assert_equal Arangodm::Database.default, db_obj
	end

	def test_default_db
		db_obj = Arangodm::Database.new(name: 'test2', user: 'test_user', password: 'password')
		Arangodm::Database.default = 'test2'
		assert_equal Arangodm::Database.default, db_obj
	end

	def test_connect
		api = Arangodm::Api.new
		body = <<~EOT
			{"jwt":"eyJhbGciOiJIUzI1NiI..x6EfI","must_change_password":false}
		EOT
		api.expects(:post)
			.with(address: '_open/auth', body: {username: 'test_user', password: 'test_password'})
			.returns(OpenStruct.new(body: body))
		db = Arangodm::Database.new(
			name: 'db',
			user: 'test_user',
			password: 'test_password',
			api: api
		)
		db.connect
		assert_equal db.auth_header, {Authorization: "bearer eyJhbGciOiJIUzI1NiI..x6EfI"}
	end

	def test_header
		db = Arangodm::Database.new(
			name: 'db',
			user: 'test_user',
			password: 'test_password'
		)
		assert_raises(RestClient::Unauthorized) { db.auth_header }
	end

end