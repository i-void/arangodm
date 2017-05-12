module Arangodm
  # Document which type is edge
  class Edge < Document

    attr_reader :from, :to
    attr_accessor :attributes

    def initialize(id: nil, rev: nil, collection:, attributes: {}, from:, to:)
      super(id: id, rev: rev, collection: collection, attributes: attributes)
      @from = from
      @to = to
    end

    class << self
      def create_from_arango(hash:, collection:)
        new(
          id: hash['_key'.to_sym],
          rev: hash['_rev'.to_sym],
          from: hash['_from'.to_sym],
          to: hash['_to'.to_sym],
          collection: collection,
          attributes: hash.except(:'_key', :'_rev', :'_id', :'_from', :'_to')
        )
      end
    end

  end
end