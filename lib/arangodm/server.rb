module Arangodm

  # @attr [String] host
  #   - default: http://127.0.0.1:8529
  # @attr_reader [String] jwt
  # @attr_reader [Arangodm::User] user
  class Server
    # @!method get(address:,body:,headers:,authorized:true)
    # @!method post(address:,body:,headers:,authorized:true)
    # @!method put(address:,body:,headers:,authorized:true)
    # @!method delete(address:,body:,headers:,authorized:true)
    # @param [String] address
    # @param [Hash{String=>String}] body
    # @param [Hash{Symbol=>String}] headers
    # @param [Boolean] authorized
    # @return [RestClient::Response]

    include ActiveAttr::Default

    attribute :host, default: 'http://127.0.0.1:8529'
    attr_reader :jwt
    attr_reader :user

    class ResponseError < StandardError; end
    class NotConnectedError < StandardError; end


    # Hosts the post, get, put, delete methods
    #
    # @raise [ResponseError] if restclient raises errors
    # @return [Hash] response body of the RestClient
    def method_missing(method, **arguments, &block)
      available_delegates = [:post, :get, :put, :delete]
      if available_delegates.include? method
        begin
          response = unleash(
            address: arguments[:address],
            type: method,
            body: arguments[:body],
            headers: arguments[:headers],
            authorized: (arguments[:authorized].nil? ? true : arguments[:authorized])
          )
        rescue RestClient::Exception => err
          raise ResponseError.new([err.message].join(':'))
        else
          JSON.parse(response.body, {:symbolize_names => true})
        end
      else
        super
      end
    end


    # Authenticates the user and returns jwt (auth digest) to server
    #
    # @param [Arangodm::User] user user that will be authenticated
    # @return [String] jwt
    def autheticate(user:)
      @user = user
      @jwt = user.authenticate(self)
    end


    # @return [Arangodm::Database] the selected database of the current server
    def db
      result = get(address: '_api/database/current')[:result]
      result.keys.each { |key| result[key.to_s.underscore.to_sym] = result.delete(key) }
      result[:server] = self
      Arangodm::Database.new result
    end


    # @return [Array<String>] the db list for the authenticated user
    def user_db_names
      get(address: '_api/database/user')[:result]
    end


    # @return [Array<String>] names of all databases
    def db_names
      get(address: '_api/database')[:result]
    end


    # Creates a database with given users
    #
    # @param [String] db_name name of the database
    # @param [Array<Arangodm::User>] user_list: which users can use this db
    # @return [Boolean]
    def create_db(db_name:, user_list: [user])
      post(
        address: '_api/database',
        body: {
          name: db_name,
          users: user_list.map { |user| {username: user.username} }
        }
      )[:result]
    end


    # Drops an existing database
    #
    # @param [String] db_name
    # @return [Boolean] result
    def drop_db(db_name:)
      delete(address: '_api/database/' + db_name)[:result]
    end

    private

    # Sends data to RestClient and get response
    #
    # @param [Boolean] authorized if this param sends true authorization header will be added to the request headers
    # @param [String] address api's request address for specific action
    # @param [Symbol] type http method of the request ex: post, get, put, delete
    # @param [Hash{Symbol=>String}] headers request headers
    # @return [RestClient::Response]
    def unleash(address:, type:, body:, headers:, authorized:)
      params = {
        method: type,
        url: "#{host}/#{address}",
        timeout: 10
      }
      params[:payload] = body.to_json if body
      params[:headers] = headers ? headers : {}
      if not authorized.nil? and authorized
        raise NotConnectedError.new("You must authenticate api first") unless jwt
        params[:headers][:Authorization] = "bearer #{jwt}"
      end
      RestClient::Request.execute params
    end

  end
end