# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/eo/site"
require_relative "../lib/eo/registry"
require_relative "../lib/eo/opener"
require_relative "../lib/eo/cli"

class CLITest < Minitest::Test
  def setup
    @saved_sites = Eo::Registry.instance_variable_get(:@sites).dup
    @saved_aliases = Eo::Registry.instance_variable_get(:@aliases).dup
    Eo::Registry.instance_variable_set(:@sites, {})
    Eo::Registry.instance_variable_set(:@aliases, {})

    Eo::Registry.register("ex", Eo::Site.new(
      description: "Example",
      default_url: "https://example.com"
    ) { |s|
      s.route "dash", url: "https://example.com/dash", description: "Dashboard"
    })

    @opened_urls = []
    test_urls = @opened_urls
    Eo::Opener.define_singleton_method(:open) { |url| test_urls << url }
  end

  def teardown
    Eo::Registry.instance_variable_set(:@sites, @saved_sites)
    Eo::Registry.instance_variable_set(:@aliases, @saved_aliases)
    Eo::Opener.define_singleton_method(:open) { |url| system("open", "-a", "Safari", url) }
  end

  def test_opens_default_url
    Eo::CLI.run(["ex"])
    assert_equal "https://example.com", @opened_urls.last
  end

  def test_opens_subcommand_url
    Eo::CLI.run(["ex", "dash"])
    assert_equal "https://example.com/dash", @opened_urls.last
  end

  def test_unknown_site_exits
    assert_raises(SystemExit) do
      capture_io { Eo::CLI.run(["bogus"]) }
    end
  end

  def test_unknown_subcommand_exits
    assert_raises(SystemExit) do
      capture_io { Eo::CLI.run(["ex", "nope"]) }
    end
  end

  def test_no_args_exits
    assert_raises(SystemExit) do
      capture_io { Eo::CLI.run([]) }
    end
  end
end
