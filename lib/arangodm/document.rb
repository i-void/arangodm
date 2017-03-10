module Arangodm
  class Document < Collection
    include ActiveAttr::Default

    attribute :type, default: 2

  end
end