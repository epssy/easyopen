# frozen_string_literal: true

module Eo
  class Site
    attr_reader :description, :note

    def initialize(description:, default_url:, note: nil, &block)
      @description = description
      @default_url = default_url
      @note = note
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
