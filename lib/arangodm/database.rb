module Arangodm

  # @attr [String] name
  # @attr [Integer] id
  # @attr [String] path
  # @attr [true|false] is_system
  class Database
    include ActiveAttr::Default
    extend Arangodm::Multiton

    attribute :name, type: String
    attribute :id, type: Integer
    attribute :path, type: String
    attribute :is_system, type: Boolean

  end
end