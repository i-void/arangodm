module Arangodm
  class Api
    # @!method get(address:,body:,headers:,authorized:true)
    # @!method post(address:,body:,headers:,authorized:true)
    # @!method put(address:,body:,headers:,authorized:true)
    # @!method delete(address:,body:,headers:,authorized:true)
    # @param [String] address
    # @param [Hash{String=>String}] body
    # @param [Hash{Symbol=>String}] headers
    # @param [True|False] authorized
    # @return [RestClient::Response]

    include ActiveAttr::Default

    # @!attribute server [rw]
    #   @return [Arangodm::Server]
    attribute :server

    class ResponseError < StandardError; end
    class NotConnectedError < StandardError; end

    # @return [String]
    attr_reader :jwt

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
            authorized: arguments[:authorized]
          )
        rescue RestClient::Exception => err
          raise ResponseError.new([err.message].join(':'))
        else
          JSON.parse(response.body)
        end
      else
        super
      end
    end

    # Authenticates the user and binds jwt (auth digest) to api
    #
    # @param [Arangodm::User] user user that will be authenticated
    # @return [String] jwt
    def authenticate(user:)
      @jwt = user.authenticate(self)
    end

    def db
      @db ||= server.current_db(self)
    end

    private

    # Sends data to RestClient and get response
    #
    # @param [True|False] authorized if this param sends true authorization header will be added to the request headers
    # @param [String] address api's request address for specific action
    # @param [Symbol] type http method of the request ex: post, get, put, delete
    # @param [Hash{Symbol=>String}] headers request headers
    #
    # @return [RestClient::Response]
    def unleash(address:, type:, body:, headers:, authorized:)
      params = {
        method: type,
        url: "#{server.host}/#{address}",
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