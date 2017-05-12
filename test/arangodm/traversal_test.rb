require_relative '../test_helper'
require 'ostruct'

class TraversalTest < Minitest::Test

  def test_to_h

    collection = mock('collection')
    collection.stubs(:name).returns('test_collection')

    document = Arangodm::Document.new(
      id: 145,
      collection: collection
    )

    traversal = Arangodm::Traversal.new(
       start_vertex: document,
       edge_collection: "edge_collection",
       direction: 'inbound',
       max_depth: 1,
       init: "result.count = 0; result.vertices = [ ];",
       visitor: "result.count++; result.vertices.push(vertex);",
       uniqueness: {vertices: "global"}
    )

    assert_equal(traversal.to_h, {
      startVertex: 'test_collection/145',
      edgeCollection: 'edge_collection',
      direction: 'inbound',
      maxDepth: 1,
      init: "result.count = 0; result.vertices = [ ];",
      visitor: "result.count++; result.vertices.push(vertex);",
      uniqueness: {vertices: "global"}
    })
  end

end