require 'test_helper'

class ApiTest < Minitest::Test

	def setup
		@api = Arangodm::Api.new
	end

	def test_method_missing
		params = {
			method: :post,
			url: "#{@api.host}/test-url",
			timeout: 10,
			payload: {body: 'ok'},
			headers: {a_header: 'ok'}
		}
		RestClient::Request.expects(:execute).with(params).returns(true)
		result = @api.post(
			address: 'test-url',
			body: {body: 'ok'},
			headers: {a_header: 'ok'}
		)
		assert result
	end

	def test_method_missing_without_body
		params = {
			method: :get,
			url: "#{@api.host}/test-url",
			timeout: 10
		}
		RestClient::Request.expects(:execute).with(params).returns(true)
		result = @api.get(
			address: 'test-url'
		)
		assert result
	end

	def test_method_missing_with_real_missing_method
		assert_raises(NoMethodError) { @api.unknown }
	end
end