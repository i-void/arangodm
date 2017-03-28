module Arangodm
  # Includes collection based operations
  module CollectionOperations
    # Drops a collection from database
    #   (see https://docs.arangodb.com/3.1/HTTP/Collection/Creating.html)
    #   for parameters
    #
    # @param [String] name
    # @param [Boolean] is_system Whether or not the collection to drop is a
    #   system collection. This parameter must be set to true in order to drop
    #   a system collection.
    # @return [Hash{Symbol=>String}] response of arango server
    def drop_collection(name:, is_system: false)
      address = [self.address, '_api/collection', name].join('/')
      address += '?isSystem=true' if is_system
      server.delete address: address
    end

    # Truncates a collection in database
    #   (see https://docs.arangodb.com/3.1/HTTP/Collection/Creating.html)
    #   for parameters
    #
    # @param [String] name
    # @return [Hash{Symbol=>String}] response of arango server
    def truncate_collection(name:)
      server.put(
        address: [adress, '_api/collection', name, 'truncate'].join('/')
      )
    end

    # @return [Hash{Symbol=>String}] collection data
    def collection_data(name:)
      server.get(
        address: [address, '_api/collection', name].join('/')
      )
    end

    # @return [Hash{Symbol=>String}] collection properties
    def collection_properties(name:)
      server.get(
        address: [address, '_api/collection', name, 'properties'].join('/')
      )
    end

    # @return [Integer] document count in the collection
    def collection_document_count(name:)
      server.get(
        address: [address, '_api/collection', name, 'count'].join('/')
      )[:count]
    end

    # @return [Hash{Symbol=>String}] statistics of the collection
    def collection_statistics(name:)
      server.get(
        address: [address, '_api/collection', name, 'figures'].join('/')
      )
    end

    # @return [String] collection revision id
    def collection_revision_id(name:)
      server.get(
        address: [address, '_api/collection', name, 'revision'].join('/')
      )[:revision]
    end

    # @return [String] collection checksum
    def collection_checksum(name:)
      server.get(
        address: [address, '_api/collection', name, 'checksum'].join('/')
      )[:checksum]
    end

    # Loads a collection into memory.
    #
    # @param [Boolean] count If set, this controls whether the return value
    #   should include the number of documents in the collection. Setting count
    #   to false may speed up loading a collection. The default value for count
    #   is true.
    # @return [Hash{Symbol=>String}] collection data
    def load_collection_to_memory(name:, count: false)
      server.put(
        address: [address, '_api/collection', name, 'load'].join('/'),
        body: { count: count }
      )
    end

    # Unloads a collection from memory.
    #
    # @return [Hash{Symbol=>String}] collection data
    def unload_collection_from_memory(name:)
      server.put(
        address: [address, '_api/collection', name, 'unload'].join('/')
      )
    end

    # Changes collection properties
    #
    # @raise [RuntimeError] if no changeable data given
    # @return [Hash{Symbol=>String}] collection data
    def change_collection_properties(
        name:, wait_for_sync: nil, journal_size: nil
    )
      props = {}
      props[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
      props[:journalSize] = journal_size unless journal_size.nil?
      raise "You didn't give any prop for change" if props.empty?
      server.put(
        address: [address, '_api/collection', name, 'properties'].join('/'),
        body: props
      )
    end

    # Renames the collection
    #
    # @param [String] name new name
    # @return [Hash{Symbol=>String}] collection data
    def rename_collection(name:)
      server.put(
        address: [address, '_api/collection', name, 'rename'].join('/'),
        body: { name: name }
      )
    end
  end
end