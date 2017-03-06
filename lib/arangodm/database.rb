module Arangodm
  class Database
    extend Arangodm::Multiton

    class NotConnectedError < StandardError; end

    attr_reader :name, :user, :password, :api, :jwt

    def initialize(name:, user:, password:, server: nil, api: Api.new(server: server))
      @name = name
      @user = user
      @password = password
      @api = api
      @host = host
    end

    def auth_header
      connect unless jwt
      raise NotConnectedError unless jwt
      {Authorization: "bearer #{jwt}"}
    end

    def connect
      result = api.post(
        address: '_open/auth',
        body: {username: user, password: password}
      ).body
      @jwt = JSON.parse(result)["jwt"]
    end


  end
end