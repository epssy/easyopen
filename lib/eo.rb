# frozen_string_literal: true

require_relative "eo/cli"
require_relative "eo/config"
require_relative "eo/opener"
require_relative "eo/registry"

# Auto-load all site definitions
Dir[File.join(__dir__, "..", "sites", "*.rb")].each { |f| require f }
