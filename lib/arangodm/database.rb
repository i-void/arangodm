module Arangodm

  # @attr [String] name
  # @attr [Integer] id
  # @attr [String] path
  # @attr [Boolean] is_system
  # @attr [Arangodm::Server] server
  class Database
    # @!parse extend Arangodm::Multiton::ClassMethods

    class CollectionTypeError < RuntimeError;end

    include ActiveAttr::Default
    include Arangodm::Multiton

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
    #   (see https://docs.arangodb.com/3.1/HTTP/Collection/Creating.html) for parameters
    #
    # @param [String] name of the collection to be created
    # @param [Integer] replication_factor
    # @param [Boolean] allow_user_keys (see keyOptions => AllowUserKeys)
    # @param [Boolean] fire_and_forget (see waitForSync)
    # @param [Boolean] only_in_memory (see isVolatile)
    # @param [Integer] number_of_shards
    # @param [Arangodm::Collection::TYPES] type (see type)
    # @param [Boolean] is_system (see isSystem)
    # @return [Hash{Symbol=>String}] response of arango server
    def create_collection(
      name:,
      replication_factor: 1,
      allow_user_keys: false,
      fire_and_forget: true,
      only_in_memory: false,
      number_of_shards: 1,
      type: :document,
      is_system: false
    )
      server.post(
        address: [adress, '_api/collection'].join('/'),
        body: {
          name: name,
          replicationFactor: replication_factor,
          keyOptions: {
            allowUserKeys: allow_user_keys,
          },
          isSystem: is_system,
          waitForSync: (not fire_and_forget),
          isVolatile: only_in_memory,
          numberOfShards: number_of_shards,
          type: Arangodm::Collection::TYPES[type]
        }
      )
    end

    # Gets the collection from database
    #
    # @param [String] name collection name
    # @return [Arangodm::Document, Arangodm::Edge]
    def collection(name:)


      # runs edge or document method
      send(type, name: name, response: response)
    end

    # Gets the edge from database
    def edge(name:)
      response = collection_data(name: name)
      type = Arangodm::Collection::TYPES.find { |(_, value)| value == response[:type] }.first
      raise CollectionTypeError.new("Type of #{name} is document") if type == :document
      Arangodm::Edge.new(response)
    end

    # Gets the document from database
    def document(name:)
      response = collection_data(name: name)
      type = Arangodm::Collection::TYPES.find { |(_, value)| value == response[:type] }.first
      raise CollectionTypeError.new("Type of #{name} is edge") if type == :edge
      Arangodm::Document.new(response)
    end


    # Drops a collection from database
    #   (see https://docs.arangodb.com/3.1/HTTP/Collection/Creating.html) for parameters
    #
    # @param [String] name
    # @param [Boolean] is_system Whether or not the collection to drop is a system collection.
    #   This parameter must be set to true in order to drop a system collection.
    # @return [Hash{Symbol=>String}] response of arango server
    def drop_collection(name:, is_system: false)
      address = [self.address, '_api/collection', name].join('/')
      address += '?isSystem=true' if is_system
      server.delete address: address
    end


    # Truncates a collection in database
    #   (see https://docs.arangodb.com/3.1/HTTP/Collection/Creating.html) for parameters
    #
    # @param [String] name
    # @return [Hash{Symbol=>String}] response of arango server
    def truncate_collection(name:)
      server.put address: [self.adress, '_api/collection', name, 'truncate'].join('/')
    end

    private

    # @return [Hash{Symbol=>String}] collection data
    def collection_data(name:)
      server.get(
        address: [address, '_api/collection', name].join('/')
      )
    end

  end
end