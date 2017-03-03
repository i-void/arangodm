module Arangodm
  class Databases
    class << self
      attr_writer :default

      def default
        @default || table[0]
      end

      def table
        @table || []
      end

      def add(name:, user:, password:)
        table << Database.new(name: name, user: user, password: password)
      end

      def get(name:)
        table.find { |database| database.name == name }
      end
    end
  end
end