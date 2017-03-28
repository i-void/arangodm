module Arangodm
  # Collection which type is edge
  class Edge < Collection
    include ActiveAttr::Default

    attribute :type, default: 3
  end
end