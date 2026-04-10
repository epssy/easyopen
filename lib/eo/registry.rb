# frozen_string_literal: true

module Eo
  module Registry
    @sites = {}
    @aliases = {}

    def self.register(*names, site)
      primary = names.first.to_s
      @sites[primary] = site
      names.each { |n| @aliases[n.to_s] = primary }
    end

    def self.fetch(name)
      primary = @aliases[name.to_s]
      primary ? @sites[primary] : nil
    end

    def self.each(&block)
      @sites.sort.each(&block)
    end

    def self.all_names
      @aliases.keys.sort
    end

    def self.names_for(name)
      primary = @aliases[name.to_s]
      return [] unless primary

      @aliases.select { |_, v| v == primary }.keys
    end
  end
end
