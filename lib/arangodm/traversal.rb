module Arangodm
  # Runs traversal queries against arangodb
  class Traversal
    include ActiveAttr::Default

    attribute :start_vertex
    attribute :edge_collection
    attribute :direction
    attribute :max_depth
    attribute :init
    attribute :visitor
    attribute :uniqueness

    def to_h
      self.start_vertex = start_vertex.id_path
      attributes.map do |key, value|
        [key.camelize(:lower).to_sym, value]
      end.to_h
    end

    def address(db)
      [db.address, '_api/traversal'].join('/')
    end

    def run(db:, as:)
      result = db.server.post(address: address(db), body: traversal.to_h)
      result_collection = db.collection(
        name: as, type: Arangodm::Collection::TYPES[:document]
      )
      result[:result][:vertices].map do |vertex|
        Arangodm::Document.create_from_arango hash: vertex,
                                              collection: result_collection
      end
    end
  end
end
