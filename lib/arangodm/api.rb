module Arangodm
  class Api

    attr_reader :server

    def initialize(server: nil)
      @server = server ? Arangodm::Server.list[server] : Arangodm::Server.default
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
        url: "#{server.host}/#{address}",
        timeout: 10
      }
      params[:payload] = body.to_json if body
      params[:headers] = headers if headers
      RestClient::Request.execute params
    end

  end
end