require 'httparty'
require 'nokogiri'

module Panties
  class Client
    include HTTParty

    attr_reader :token

    def initialize(uri, password)
      @base_uri = uri
      @password = password

      discover_urls
      authenticate
    end

    def posts
      get(@posts_path)
    end

    def timeline
      get(@timeline_path, body: { token: token })
    end

    def create_post(body)
      post = {
        body: body
      }

      post(@posts_path, body: { post: post, token: @token })
    end

  private

    def discover_urls
      # Load front page and start tag discovery
      r = get('/')
      raise "Failed to perform link discovery" unless r.code == 200

      doc = Nokogiri::HTML(r.body)

      @posts_path    = find_link(doc, 'pants.post') || '/posts.json'
      @login_path    = find_link(doc, 'pants.login') || '/login.json'
      @timeline_path = find_link(doc, 'pants.timeline') || '/network.json'
    end

    def find_link(doc, rel)
      el = doc.css("link[rel=\"#{rel}\"]").first
      el ? el[:href] : nil
    end

    def authenticate
      r = post(@login_path, body: { login: { password: @password }})
      raise "Failed to authenticate" unless r.code == 200
      @token = r['token']
    end

    def get(path, *args)
      self.class.get(URI.join(@base_uri, path), *args)
    end

    def post(path, *args)
      self.class.post(URI.join(@base_uri, path), *args)
    end
  end
end
