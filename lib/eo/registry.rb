# frozen_string_literal: true

module Eo
  module Registry
    @sites = {}

    def self.register(name, site)
      @sites[name.to_s] = site
    end

    def self.fetch(name)
      @sites[name.to_s]
    end

    def self.each(&block)
      @sites.sort.each(&block)
    end
  end
end
