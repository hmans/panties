require 'httparty'
require 'nokogiri'

module Panties
  class Client
    include HTTParty

    def initialize(uri)
      @base_uri = uri
      discover_urls
    end

    def posts
      get(@posts_path)
    end

  private

    def discover_urls
      # Load front page and start tag discovery
      r = get('/')
      doc = Nokogiri::HTML(r.body)

      # Find posts JSON
      links = doc.css('link[rel="pants.posts"]')
      @posts_path = links.any? ? links.first[:href] : '/posts.json'
    end

    def get(path, *args)
      self.class.get(URI.join(@base_uri, path), *args)
    end

    def post(path, *args)
      self.class.post(URI.join(@base_uri, path), *args)
    end
  end
end
