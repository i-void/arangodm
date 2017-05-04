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

  end
end