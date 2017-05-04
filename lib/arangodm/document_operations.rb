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

    # Create multiple documents
    #
    # @param [Array<Hash>] documents
    def create_documents(documents:)
      db.server.post(address: [db.address, '_api/document', name].join('/'), body: documents)
    end

    # Update multiple documents
    #
    # @param [Array<Hash>] documents
    #   there must be '_key' properties in the documents array
    def update_documents(documents:)
      db.server.put(address: [db.address, '_api/document', name].join('/'), body: documents)
    end

    # Delete multiple documents
    #
    # @param [Array<String>] keys array of keys/ids
    def delete_documents(keys:)
      documents = keys.map { |key| {'_key': key} }
      db.server.delete(address: [db.address, '_api/document', name].join('/'), body: documents)
    end

  end
end
