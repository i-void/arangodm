module Arangodm
  class Edge < Collection
    include ActiveAttr::Default

    attribute :type, default: 3

  end
end