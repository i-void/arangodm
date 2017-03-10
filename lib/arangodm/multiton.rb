module Arangodm

  # Adds multiton pattern for generating class instances, and store them inside self.
  module Multiton

    # @return [String] default multiton instance name
    def default
      list[@default]
    end

    # Sets the default multiton instance
    # @param [String] val default instance name for multiton
    # @return [String]
    def default=(val)
      @default = val
    end

    # @return [Hash] all multiton instances
    def list
      @list ||= {}
    end

    # Initialize the instance and adds it to the multiton list
    # @return [instance]
    def new(**attributes)
      @default ||= attributes[:name]
      list[attributes[:name]] = super(attributes)
    end
  end
end