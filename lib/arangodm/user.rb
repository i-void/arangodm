module Arangodm
	class User
		include ActiveAttr::Default

		attribute :username, default: 'Osman', type: Arangodm::Api

		validates :username, numericality: {only_integer: true}

	end
end