module Arangodm
  class Database
    extend Arangodm::Multiton

    attr_reader :name, :user, :password, :api, :jwt

    def initialize(name:, user:, password:, server: nil, api: Api.new(server: server))
      @name = name
      @user = user
      @password = password
      @api = api

      api.authenticate(user, password)
    end


  end
end