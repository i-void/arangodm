require 'test_helper'

class DatabaseTest < Minitest::Test

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

end