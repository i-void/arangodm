module Arangodm
  # This is the module which will be included in models
  module Model
    def self.included(base)
      base.extend ClassMethods
    end

    # Static methods
    module ClassMethods
      def db(name=nil)
        if name
          Arangodm::Server.default.db = name
        else
          @db ||= Arangodm::Database.default
        end
      end

      def has_many(edge, as: edge)
        collection.define_singleton_method(edge) do |document|
          args = { start_vertex: document, edge_collection: edge,
                   direction: 'outbound', max_depth: 1,
                   init: "result.count = 0; result.vertices = [ ];",
                   visitor: "result.count++; result.vertices.push(vertex);",
                   uniqueness: {vertices: "global"} }
          traversal = Traversal.new args
          traversal.run(db: db, as: as)
        end
      end

      # Sets and gets the collection for model
      #
      # @return [Arangodm::Collection]
      def collection(name=nil)
        if name
          @collection = db.collection(name: name)
        else
          @collection || raise('Please give a collection name for this model')
        end
      end

      # finds the document
      def find(id)
        collection.find(id: id)
      end

      # creates multiple documents
      def create_documents(documents)
        collection.create_documents documents: documents
      end

      # updates multiple documents
      def update_documents(documents)
        collection.update_documents documents: documents
      end

      # updates multiple documents
      def delete_documents(keys)
        collection.delete_documents keys: keys
      end

    end
  end
end
