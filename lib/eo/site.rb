# frozen_string_literal: true

module Eo
  class Site
    attr_reader :description

    def initialize(description:, default_url:, &block)
      @description = description
      @default_url = default_url
      @routes = {}
      block&.call(self)
    end

    def route(name, url:, description: nil)
      @routes[name.to_s] = { url: url, description: description }
    end

    def url_for(subcommand)
      return @default_url if subcommand.nil?

      entry = @routes[subcommand]
      entry ? entry[:url] : nil
    end

    def subcommands
      @routes.map { |name, entry| [name, entry[:description]] }
    end
  end
end
