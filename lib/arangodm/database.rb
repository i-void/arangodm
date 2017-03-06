module Arangodm
  class Database
    extend Arangodm::Multiton

    attr_reader :name, :user, :password, :api, :jwt

    def initialize(name:, user:, password:, api: Api.new)
      @name = name
      @user = user
      @password = password
      @api = api
    end

    def auth_header
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