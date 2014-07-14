require 'httparty'
require 'nokogiri'

module Panties
  class Client
    include HTTParty

    attr_reader :token
    attr_reader :site

    def initialize(uri, password)
      @base_uri = uri
      @password = password

      load_site_data
      authenticate
    end

    def posts
      get(@posts_path)
    end

    def timeline
      get(endpoints['timeline'], body: { token: token })
    end

    def create_post(body)
      post = {
        body: body
      }

      post(endpoints['posts'], body: { post: post, token: @token })
    end

  private

    def load_site_data
      # Load front page and start tag discovery
      r = get('/')
      raise "Failed to perform link discovery" unless r.code == 200

      doc = Nokogiri::HTML(r.body)
      pants_path = find_link(doc, 'pants') || '/pants.json'

      # Load site data
      r = get(pants_path)
      raise "Failed to load site data" unless r.code == 200
      @site = r.to_hash['pants']
    end

    def find_link(doc, rel)
      el = doc.css("link[rel=\"#{rel}\"]").first
      el ? el[:href] : nil
    end

    def authenticate
      r = post(endpoints['login'], body: { login: { password: @password }})
      raise "Failed to authenticate" unless r.code == 200
      @token = r['token']
    end

    def get(path, *args)
      self.class.get(URI.join(@base_uri, path), *args)
    end

    def post(path, *args)
      self.class.post(URI.join(@base_uri, path), *args)
    end

    def endpoints
      @site['endpoints']
    end
  end
end
