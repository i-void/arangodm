module Arangodm
  class Api

    attr_reader :host

    def initialize(host: 'http://127.0.0.1:8529')
      @host = host
    end

    def post(address:, body:, headers:)
      unleash(address: address, type: :post, body: body, headers: headers)
    end

    def get(address:, body:, headers:)
      unleash(address: address, type: :get, body: body, headers: headers)
    end

    def put(address:, body:, headers:)
      unleash(address: address, type: :put, body: body, headers: headers)
    end

    def delete(address:, body:, headers:)
      unleash(address: address, type: :delete, body: body, headers: headers)
    end

    def unleash(address:, type:, body:, headers:)
      params = {
        method: type,
        url: "#{host}/#{address}",
        timeout: 10
      }
      params[:payload] = body if body
      params[:headers] = headers if headers
      RestClient::Request.execute params
    end

  end
end