module Arangodm
  class Query

    attr_reader :collection, :sign

    def initialize(collection:, sign: nil)
      @collection = collection
      @sign = sign
      @text = "FOR #{sign} IN #{collection.name}"
      yield self
    end

    def sign
      @sign ||= collection.first
    end

    def limit(val)
      @text += "\n\t LIMIT #{val}"
    end

    def retscope(val=nil)
      val ||= sign
      @text += "\n\t RETURN #{val}"
    end

    def all
      retscope
    end

    def run(count=false, batch_size=500)
      response = collection.db.server.post(
        address: "_api/cursor",
        body: {
          query: @text,
          count: count,
          batchSize: batch_size
        }
      )
      response[:result].map do |doc|
        Arangodm::Document.create_from_arango hash: doc, collection: collection
      end
    end

  end
end