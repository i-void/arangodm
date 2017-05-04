module Arangodm
  # @attr [String] name Name of the server
  #   - default: 'default'
  # @attr [String] host
  #   - default: http://127.0.0.1:8529
  # @attr_reader [String] jwt
  # @attr_reader [Arangodm::User] user
  class Server
    # @!parse extend Arangodm::Multiton::ClassMethods
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
    include Arangodm::Multiton

    attribute :name, default: 'default'
    attribute :host, default: 'http://127.0.0.1:8529'
    attr_reader :jwt
    attr_reader :user

    class ResponseError < RuntimeError; end
    class NotConnectedError < RuntimeError; end


    # Hosts the post, get, put, delete methods
    #
    # @raise [ResponseError] if restclient raises errors
    # @return [Hash] response body of the RestClient
    def method_missing(method, **arguments, &block)
      available_delegates = [:post, :get, :put, :delete]
      if available_delegates.include? method
        send_request(arguments, method)
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

    # If name given returns the named database as Database object
    #   else returns default database
    #
    # @param [String] name
    # @return [Arangodm::Database]
    def db(name: nil)
      if name
        result = get(address: "_db/#{name}/_api/database/current")[:result]
        result.keys.each do |key|
          result[key.to_s.underscore.to_sym] = result.delete(key)
        end
        result[:server] = self
        Arangodm::Database.new(result)
      else
        Arangodm::Database.default
      end
    end

    # Sets the named database as default
    #
    # @return [Arangodm::Database]
    def db=(name)
      db(name: name).tap(&:set_as_default)
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
    # @param [Array<Arangodm::User>] user_list which users can use this db
    # @return [Boolean]
    def create_db(db_name:, user_list: [user])
      post(
        address: '_api/database',
        body: {
          name: db_name,
          users: user_list.map { |user| { username: user.username } }
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

    def extract_params(arguments, method)
      authorized = arguments[:authorized]
      {
        address: arguments[:address],
        type: method,
        body: arguments[:body],
        headers: arguments[:headers],
        authorized: (authorized.nil? ? true : authorized)
      }
    end

    def send_request(arguments, method)
      params = extract_params(arguments, method)
      response = unleash params
      JSON.parse(response.body, symbolize_names: true)
    rescue RestClient::Exception => err
      msg = [err.message].join(':') + "\n#{params.pretty_inspect}"
      raise ResponseError, msg
    end

    # Sends data to RestClient and get response
    #
    # @param [Boolean] authorized if this param sends true authorization header
    #   will be added to the request headers
    # @param [String] address api's request address for specific action
    # @param [Symbol] type http method of the request ex: post, get, put, delete
    # @param [Hash{Symbol=>String}] headers request headers
    # @return [RestClient::Response]
    def unleash(address:, type:, body:, headers:, authorized:)
      params = { method: type, url: "#{host}/#{address}", timeout: 10 }
      params[:payload] = body.to_json if body
      params[:headers] = headers ? headers : {}
      if !authorized.nil? && authorized
        raise NotConnectedError, 'You must authenticate api first' unless jwt
        params[:headers][:Authorization] = "bearer #{jwt}"
      end
      RestClient::Request.execute params
    end
  end
end