# frozen_string_literal: true

require "yaml"

module Eo
  module Config
    RC_PATH = File.join(Dir.home, ".eorc")

    def self.load
      return {} unless File.exist?(RC_PATH)

      YAML.safe_load(File.read(RC_PATH)) || {}
    end

    def self.browser
      load["browser"] || "Safari"
    end

    def self.accounts(site_name)
      all = load["accounts"] || {}
      names = Registry.names_for(site_name)
      names.each do |name|
        result = all[name]
        return result if result
      end
      all[site_name.to_s] || {}
    end
  end
end
