module Arangodm
  class Api

    attr_reader :host

    def initialize(host: 'http://127.0.0.1:8529')
      @host = host
    end

    def method_missing(method, **arguments, &block)
      available_delegates = [:post, :get, :put, :delete]
      if available_delegates.include? method
        unleash(
          address: arguments[:address],
          type: method,
          body: arguments[:body],
          headers: arguments[:headers]
        )
      else
        super
      end
    end

    private

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