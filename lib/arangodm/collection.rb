module Arangodm
  # @attr [String] name
  # @attr [Arangodm::Database] db
  # @attr [String] name of the collection to be created
  # @attr [Integer] replication_factor
  # @attr [Boolean] allow_user_keys (see keyOptions => AllowUserKeys)
  # @attr [Boolean] fire_and_forget (see waitForSync)
  # @attr [Boolean] only_in_memory (see isVolatile)
  # @attr [Integer] number_of_shards
  # @attr [Arangodm::Collection::TYPES] type (see type)
  # @attr [Boolean] is_system (see isSystem)
  class Collection
    include ActiveAttr::Default
    include Arangodm::DocumentOperations

    TYPES = {
      document: 2,
      edge: 3
    }.freeze

    attribute :name
    attribute :db
    attribute :is_system
    attribute :status
    attribute :type
    attribute :replication_factor, default: 1
    attribute :allow_user_keys, default: false
    attribute :fire_and_forget, default: true
    attribute :only_in_memory, default: false
    attribute :number_of_shards, default: 1

    # @return [String] api adress
    def adress
      [db.adress, '_collection', name].join('/')
    end

    # Truncates this collection
    #
    # @return [Hash{Symbol=>String}] response of arango server
    def truncate
      db.truncate_collection name: name
    end

    # @return [Hash{Symbol=>String}] info of this collection
    def info
      db.collection_data name: name
    end

    # @return [String] collection checksum
    def checksum
      db.collection_checksum name: name
    end

    # @return [String] collection revision id
    def revision_id
      db.collection_revision_id name: name
    end

    # @return [Hash{Symbol=>String}] statistics of the collection
    def statistics
      db.collection_statistics name: name
    end

    # @return [Hash{Symbol=>String}] properties of this collection
    def properties
      db.collection_properties name: name
    end

    # @return [Integer] document count in this collection
    def document_count
      db.collection_document_count name: name
    end

    # Changes collection properties
    #
    # @raise [RuntimeError] if no changeable data given
    # @return [Hash{Symbol=>String}] collection data
    def change_properties(name:, wait_for_sync: nil, journal_size: nil)
      db.change_collection_properties(
        name: name,
        wait_for_sync: wait_for_sync,
        journal_size: journal_size
      )
    end

    # Renames the collection
    #
    # @param [String] name new name
    # @return [Hash{Symbol=>String}] collection data
    def rename(name:)
      db.rename_collection name: name
    end

    # Returns the edges which type is this collection
    #
    # @param [String] start_node id of the start vertex of graph
    # @return [Array<Arangodm::Edge>]
    def edges(start_node:, direction: nil)
      db.edges collection: self, start_node: start_node, direction: direction
    end
  end
end
