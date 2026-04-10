# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/eo/site"

class SiteTest < Minitest::Test
  def setup
    @site = Eo::Site.new(
      description: "Example",
      default_url: "https://example.com"
    ) { |s|
      s.route "dash", url: "https://example.com/dashboard", description: "Dashboard"
      s.route "settings", url: "https://example.com/settings", description: "Settings"
    }
  end

  def test_description
    assert_equal "Example", @site.description
  end

  def test_url_for_nil_returns_default
    assert_equal "https://example.com", @site.url_for(nil)
  end

  def test_url_for_known_subcommand
    assert_equal "https://example.com/dashboard", @site.url_for("dash")
  end

  def test_url_for_unknown_subcommand_returns_nil
    assert_nil @site.url_for("nope")
  end

  def test_subcommands
    subs = @site.subcommands
    assert_equal [["dash", "Dashboard"], ["settings", "Settings"]], subs
  end

  def test_no_routes
    bare = Eo::Site.new(description: "Bare", default_url: "https://bare.com")
    assert_equal "https://bare.com", bare.url_for(nil)
    assert_empty bare.subcommands
  end
end
