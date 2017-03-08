module Arangodm
  module Multiton

    # @return [instance] default multiton instance
    def default
      list[@default]
    end

    # Sets the default multiton instance
    # @param [instance] val default instance for multiton
    # @return [instance]
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