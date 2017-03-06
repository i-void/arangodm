module Arangodm
	module Multiton
		def default
			list[@default]
		end

		def default=(val)
			@default = val
		end

		def list
			@list ||= {}
		end

		def new(**attributes)
			@default ||= attributes[:name]
			list[attributes[:name]] = super(attributes)
		end
	end
end