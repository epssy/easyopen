# frozen_string_literal: true

module Eo
  module Opener
    def self.open(url)
      system("open", "-a", Config.browser, url)
    end
  end
end
