module Arangodm
  # @attr [String] name
  # @attr [Integer] id
  # @attr [String] path
  # @attr [Boolean] is_system
  # @attr [Arangodm::Server] server
  class Database
    # @!parse extend Arangodm::Multiton::ClassMethods

    class CollectionTypeError < RuntimeError; end

    include ActiveAttr::Default
    include Arangodm::Multiton
    include Arangodm::CollectionOperations

    attribute :name, type: String
    attribute :id, type: Integer
    attribute :path, type: String
    attribute :is_system, type: Boolean
    attribute :server

    # @return [String] api address
    def address
      "_db/#{name}"
    end

    # Drops this database and remove from the database list
    #
    # @return [Boolean] result of operation
    def drop
      server.drop_db(db_name: name).tap do |result|
        self.class.list.delete(name) if result
      end
    end

    # Creates a collection inside this database
    #   (see https://docs.arangodb.com/3.1/HTTP/Collection/Creating.html)
    #   for parameters
    #
    # @param [Arangodm::Collection] collection collection to be persisted
    # @return [Hash{Symbol=>String}] response of arango server
    def create_collection(collection)
      server.post(address: [adress, '_api/collection'].join('/'),
                  body: { name: collection.name,
                          replicationFactor: collection.replication_factor,
                          keyOptions:
                            { allowUserKeys: collection.allow_user_keys },
                          isSystem: collection.is_system,
                          waitForSync: !collection.fire_and_forget,
                          isVolatile: collection.only_in_memory,
                          numberOfShards: collection.number_of_shards,
                          type: Arangodm::Collection::TYPES[collection.type] })
    end

    # Gets the collection names of this database
    #
    # @return [Array<String>]
    def collection_names
      result = server.get(
        address: [address, '_api/collection'].join('/')
      )[:result]
      result.map { |collection| collection[:name] }
    end

    # Gets the collection from database
    #
    # @param [String] name collection name
    # @return [Arangodm::Document, Arangodm::Edge]
    def collection(name:)
      response = collection_data(name: name)
      Arangodm::Collection.new(response.merge(db: self))
    end
  end
end