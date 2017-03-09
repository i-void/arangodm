module Arangodm

  # @attr [String] name
  # @attr [String] host
  #   - default: http://127.0.0.1:8529
  class Server
    include ActiveAttr::Default
    extend Arangodm::Multiton

    attribute :name
    attribute :host, default: 'http://127.0.0.1:8529'


    def db_name(api)
      result = api.get(address: '_api/database/current')
      result['result']
    end
  end
end