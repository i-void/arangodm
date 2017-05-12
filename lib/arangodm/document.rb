module Arangodm
  # Collection which type is document
  class Document

    attr_reader :id, :rev, :collection
    attr_accessor :attributes

    def initialize(id: nil, rev: nil, collection:, attributes: {})
      @id = id
      @rev = rev
      @collection = collection
      @attributes = attributes
    end

    def id_path
      [collection.name, id].join('/')
    end

    def arango_path(id: nil)
      parts = [collection.db.address, '_api/document', collection.name]
      parts << id.to_s if id
      parts.join('/')
    end

    # Binds collection columns to methods
    #
    # @raise undefined method if column not found
    # @return [Hash] response body of the RestClient
    def method_missing(method, *arguments)
      return @attributes[method.to_sym] if @attributes.keys.include?(method)
      if @attributes.keys.map { |m| (m.to_s + '=').to_sym}.include?(method)
        @attributes[method.to_s.gsub('=', '').to_sym] = arguments[0]
      elsif collection.respond_to?(method, self)
        collection.send(method, self)
      else
        super
      end
    end

    # Saves the document to the collection
    #  if it is an already existing document it updates the document
    #  otherwise it creates a new one
    def save
      return update if id
      create
    end

    def update
      result = collection.db.server.put(address: arango_path(id: id), body: attributes)
      @rev = result[:'_rev']
    end

    def create
      result = collection.db.server.post(address: arango_path, body: attributes)
      @id = result[:'_key']
      @rev = result[:'_rev']
    end

    def delete
      collection.db.server.delete(address: arango_path(id: id))
    end

    class << self
      def create_from_arango(hash:, collection:)
        new(
          id: hash['_key'.to_sym],
          rev: hash['_rev'.to_sym],
          collection: collection,
          attributes: hash.except(:'_key', :'_rev', :'_id')
        )
      end
    end

  end
end