# frozen_string_literal: true

module Eo
  module Opener
    def self.open(url)
      system("open", "-a", "Safari", url)
    end
  end
end
