require "active_attr"
require "active_support"

module ActiveAttr
	module Default
		extend ActiveSupport::Concern
		include Attributes
		include AttributeDefaults
		include MassAssignment
		include QueryAttributes
		include TypecastedAttributes
		include ChainableInitialization
		include Serialization
		include ActiveModel::Validations
	end
end