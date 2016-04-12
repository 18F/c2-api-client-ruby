require 'json'
require 'faraday_middleware'
require 'oauth2'
require 'uri'

module C2
  class Client
    VERSION = '1.0.0'

    attr_accessor :host, :debug, :agent, :user_agent, :cookies, :endpoint

    def version
      VERSION
    end

    def initialize(args)
      @oauth_key = args[:oauth_key] or fail(":oauth_key required")
      @oauth_secret = args[:oauth_secret] or fail(":oauth_secret required")
      @user_agent = args[:user_agent] || "c2-ruby-client/#{version}"
      @oauth_redir_uri = args[:redir_uri] || 'urn:ietf:wg:oauth:2.0:oob'
      @host = args[:host] || "https://cap.18f.gov"
      @endpoint = args[:endpoint] || "/api/v2"
      @debug = args[:debug] || false

      @agent = build_agent
    end

    def get_oauth_token(options={})
      oauth_options = {
        site:            @host + @endpoint,
        authorize_url:   @host + '/oauth/authorize',
        token_url:       @host + '/oauth/token',
        redirect_uri:    @oauth_redir_uri,
        connection_opts: options.merge( { :ssl => {:verify => false}, } )
      }

      client = OAuth2::Client.new(@oauth_key, @oauth_secret, oauth_options) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger if @debug
        faraday.adapter  :excon
      end

      client.client_credentials.get_token()
    end

    def build_agent
      uri = @host + @endpoint
      opts = {
        :url => uri,
        :ssl => {:verify => false},
        :headers => {
          'User-Agent'   => @user_agent,
          'Accept'       => 'application/json',
          'Cookie'       => @cookies
        }
      }
      @token = get_oauth_token
      Faraday.new(opts) do |faraday|
        faraday.request :url_encoded
        [:mashify, :json].each{|mw| faraday.response(mw) }
        faraday.response(:raise_error)
        faraday.request :authorization, 'Bearer', @token.token
        faraday.response :logger if @debug
        faraday.adapter  :excon   # IMPORTANT this is last
      end
    end

    def method_missing(method, *args, &block)
      @agent.send(method, *args, &block)
    end

    def respond_to?(method)
      @agent.respond_to?(method)
    end
  end
end
