module Arangodm
  class Server
    extend Arangodm::Multiton

    attr_reader :name, :host

    def initialize(name: nil, host: 'http://127.0.0.1:8529')
      @api = Arangodm::Api.new(server: name)
      @name = name
      @host = host
    end

    def current_db
      result = @api.get(address: '_api/database/current').body
      JSON.parse(result)['result']
    end
  end
end