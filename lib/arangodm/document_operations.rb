module Arangodm
  # Includes document based operations
  module DocumentOperations

    # Gets a document with an id
    def find(id:)
      result = db.server.get(address: [db.address, '_api/document', name, id].join('/'))
      Arangodm::Document.new(
        id: result['_key'.to_sym],
        rev: result['_rev'.to_sym],
        collection: self,
        attributes: result.except(:'_key', :'_rev', :'_id')
      )
    end

  end
end
