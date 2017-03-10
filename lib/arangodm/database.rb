module Arangodm

  # @attr [String] name
  # @attr [Integer] id
  # @attr [String] path
  # @attr [Boolean] is_system
  # @attr [Arangodm::Server] server
  class Database
    include ActiveAttr::Default
    extend Arangodm::Multiton

    attribute :name, type: String
    attribute :id, type: Integer
    attribute :path, type: String
    attribute :is_system, type: Boolean
    attribute :server

    # Drops this database and remove from the database list
    #
    # @return [Boolean] result of operation
    def drop
      server.drop_db(db_name: name).tap do |result|
        self.class.list.delete(name) if result
      end
    end

    # Sets this database as default database for processes
    def set_as_default
      self.class.default = self.name
    end

    # Creates a collection inside this database
    #   (see https://docs.arangodb.com/3.1/HTTP/Collection/Creating.html) for parameters
    #
    # @param name [String] name of the collection to be created
    # @param [Integer] replication_factor:
    # @param [Boolean] allow_user_keys: (see keyOptions => AllowUserKeys)
    # @param [Boolean] fire_and_forget: (see waitForSync)
    # @param [Boolean] only_in_memory: (see isVolatile)
    # @param [Integer] number_of_shards:
    # @param [Boolean] edge: (see type)
    # @return [Hash{Symbol=>String}] response of arango server
    def create_collection(
      name:,
      replication_factor: 1,
      allow_user_keys: false,
      fire_and_forget: true,
      only_in_memory: false,
      number_of_shards: 1,
      edge: false
    )
      server.post(
        address: '_api/collection',
        body: {
          name: name,
          replicationFactor: replication_factor,
          keyOptions: {
            allowUserKeys: allow_user_keys,
          },
          waitForSync: (not fire_and_forget),
          isVolatile: only_in_memory,
          numberOfShards: number_of_shards,
          type: (edge ? 3 : 2)
        }
      )
    end

  end
end