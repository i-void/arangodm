module Arangodm::Query
  class Runner
    include ActiveAttr::Default

    attribute :query
    attribute :db
    attribute :batch_size, default: 500
    attribute :count, default: false

    def run(count = count, batch_size = batch_size)
      body = { query: query, count: count, batchSize: batch_size }
      response = db.server.post(address: '_api/cursor', body: body )
      response[:result]
    end
  end
end