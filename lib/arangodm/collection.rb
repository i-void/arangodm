module Arangodm

  # @attr [String] name
  # @attr [Arangodm::Database] db
  class Collection
    include ActiveAttr::Default

    TYPES = {
      document: 2,
      edge: 3
    }

    attribute :name
    attribute :db
    attribute :is_system
    attribute :status

    # @return [String] api adress
    def adress
      [db.adress, "_collection/#{name}"].join('/')
    end


    # Truncates this collection
    #
    # @return [Hash{Symbol=>String}] response of arango server
    def truncate
      db.truncate_collection name: name
    end

  end
end
