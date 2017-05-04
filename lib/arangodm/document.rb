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

    def arango_path
      [collection.db.address, '_api/document', collection.name].join('/')
    end

    def respond_to_missing?(**_)
      true
    end

    # Hosts the post, get, put, delete methods
    #
    # @raise [ResponseError] if restclient raises errors
    # @return [Hash] response body of the RestClient
    def method_missing(method, *arguments)
      return @attributes[method.to_sym] if @attributes.keys.include?(method)
      @attributes[method.to_sym] = arguments[0] if @attributes.keys.map { |m| m + '='}.include?(method)
    end

    # Saves the document to the collection
    #  if it is an already existing document it updates the document
    #  otherwise it creates a new one
    def save
      return update if id
      create
    end

    def update

    end

    def create
      result = collection.db.server.post(address: arango_path, body: attributes)
      @id = result[:'_key']
      @rev = result[:'_rev']
    end

  end
end