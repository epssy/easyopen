# frozen_string_literal: true

# Example site definition — copy this file to add a new site.
#
#   1. Name the file after your service (e.g., pagerduty.rb)
#   2. Pick a short alias for the first argument to `eo`
#   3. Set the default_url (where `eo <alias>` lands)
#   4. Add routes for subcommands (where `eo <alias> <sub>` lands)

require_relative "../lib/eo/site"

Eo::Registry.register "example", Eo::Site.new(
  description: "Example (template)",
  default_url: "https://example.com",
  note: "Auth via Okta SSO" # optional — printed to the terminal when opened
) { |s|
  s.route "help",  url: "https://example.com/help",  description: "Help center"
  s.route "docs",  url: "https://example.com/docs",  description: "Documentation"
}
