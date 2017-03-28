module Arangodm
  # Collection which type is document
  class Document < Collection
    include ActiveAttr::Default

    attribute :type, default: 2
  end
end