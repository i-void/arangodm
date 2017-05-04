require_relative '../test_helper'

class UserTest < Minitest::Test

  def test_initialization
    user = Arangodm::User.new(username: 'root', password: '12345678')

    server = Arangodm::Server.new
    server.autheticate(user: user)

    server.db = 'Blog'
    collection = server.db.collection(name: 'user')

    doc = collection.find(id: 1378572)
    pp doc
    pp doc.surname

    doc = Arangodm::Document.new(collection: collection, attributes:{name: 'cüneyt', surname: 'arkın'})
    #doc.save

    pp doc



    # @type [Arangodm::Database]
    # database = server.db
    # pp database.path
    # coll = database.drop_collection(name: '_osman', is_system: true)
    # pp database.create_collection name: 'osman'
    # pp database.truncate_collection name: 'osman'
  end
end