module Arangodm
  module Model

    def self.included(base)
      base.extend ClassMethods
    end



    module ClassMethods

      # @raise [RuntimeError] if collection not set
      # @return [Arangodm::Collection]
      def collection
        @collection || raise(RuntimeError.new("Please give a collection name for this model"))
      end

      # Sets the collection for model
      #
      # @return [Arangodm::Collection]
      def collection=(name)
        db = Arangodm::Database.default
        @collection = db.collection(name: name)
      end




    end

  end
end