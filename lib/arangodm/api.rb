module Arangodm
  class Api
    class ResponseError < StandardError; end
    class NotConnectedError < StandardError; end

    attr_reader :server, :jwt

    def initialize(server: nil)
      @server = server ? Arangodm::Server.list[server] : Arangodm::Server.default
    end

    def method_missing(method, **arguments, &block)
      available_delegates = [:post, :get, :put, :delete]
      if available_delegates.include? method
        response = unleash(
          address: arguments[:address],
          type: method,
          body: arguments[:body],
          headers: arguments[:headers],
          authorized: arguments[:authorized]
        )
        result = JSON.parse(response)
        if result["error"] != nil
          if result["error"]
            ResponseError.new([result["code"], result["error"]].join(': ')).raise
          else
            result["result"]
          end
        else
          result
        end
      else
        super
      end
    end

    def authenticate(username:, password:)
      result = api.post(
        address: '_open/auth',
        body: {username: username, password: password}
      )
      @jwt = result["jwt"]
    end

    private

    def unleash(address:, type:, body:, headers:, authorized:)
      params = {
        method: type,
        url: "#{server.host}/#{address}",
        timeout: 10
      }
      params[:payload] = body.to_json if body
      params[:headers] = headers ? headers : {}
      unless authorized.nil?
        NotConnectedError.new("You must authenticate api first").raise unless @jwt
        params[:headers][:Authorization] = "bearer #{jwt}"
      end
      RestClient::Request.execute params
    end

  end
end